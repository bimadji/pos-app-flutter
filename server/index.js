const WebSocket = require("ws");
const mysql = require("mysql2/promise");

// Setup MySQL pool
const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  database: "pos_app",
});

// Setup WebSocket server
const wss = new WebSocket.Server({ port: 8080 });

let transactions = {}; // Semua transaksi per meja
let statusPerTable = {}; // Status terakhir per meja

wss.on("connection", (ws) => {
  console.log("Client connected");

  // Kirim data awal ke client
  ws.send(
    JSON.stringify({
      type: "transactions_update",
      transactions,
      status: statusPerTable,
    })
  );

  ws.on("message", async (message) => {
    console.log("====================================");
    console.log("RAW MESSAGE FROM CLIENT:");
    console.log(message.toString());

    let data;
    try {
      data = JSON.parse(message);
    } catch (e) {
      console.log("❌ JSON Parse Error:", e);
      return;
    }

    console.log("📦 PARSED JSON FROM CLIENT:");
    console.log(data);

    // ===== CUSTOMER UPDATE CART =====
    if (data.type === "cart_update") {
      const table = data.table_number.toString();

      if (!transactions[table]) {
        transactions[table] = [];
      }

      // Hapus customer lama jika ada
      transactions[table] = transactions[table].filter(
        (t) => t.customerName !== data.customer_name
      );

      // Tambah data customer baru
      transactions[table].push({
        customerName: data.customer_name,
        items: data.items,
        total: data.total,
      });

      // Simpan di DB
      try {
        await pool.query(
          "INSERT INTO transactions (table_number, items_json, total_amount, status) VALUES (?, ?, ?, ?)",
          [
            table,
            JSON.stringify(data.items),
            data.total,
            "menunggu dikonfirmasi",
          ]
        );
      } catch (e) {
        console.error("❌ DB ERROR:", e);
      }

      if (!statusPerTable[table]) {
        statusPerTable[table] = "menunggu dikonfirmasi";
      }

      // Broadcast ke semua client
      const payload = {
        type: "transactions_update",
        transactions,
        status: { [table]: statusPerTable[table] },
      };

      wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
          client.send(JSON.stringify(payload));
        }
      });
    }

    // ===== KASIR UPDATE STATUS =====
    else if (data.type === "status_update") {
      const table = data.table_number.toString();
      const newStatus = data.status;

      // Update status di memori
      statusPerTable[table] = newStatus;

      // Simpan update status di DB
      try {
        await pool.query(
          "UPDATE transactions SET status = ? WHERE table_number = ? AND status != 'selesai'",
          [newStatus, table]
        );
      } catch (e) {
        console.error("❌ DB ERROR (status update):", e);
      }

      if (newStatus === "selesai") {
        try {
          const orders = transactions[table];

          if (orders && orders.length > 0) {
            for (const order of orders) {
              for (const item of order.items) {
                await pool.query(
                  "UPDATE products SET stock = stock - ? WHERE name = ?",
                  [item.qty, item.name]
                );

                console.log(`📉 Stok dikurangi: ${item.name} -${item.qty}`);
              }
            }
          }
        } catch (e) {
          console.error("❌ ERROR UPDATE STOCK:", e);
        }
      }

      // Broadcast ke client
      const payload = {
        type: "transactions_update",
        transactions,
        status: { [table]: newStatus },
      };

      wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
          client.send(JSON.stringify(payload));
        }
      });
    }
  });

  ws.on("close", () => {
    console.log("Client disconnected");
  });
});

console.log("WebSocket server running on ws://0.0.0.0:8080");
