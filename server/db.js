const mysql = require("mysql2/promise");

const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'nama_db'
});

module.exports = {
  saveOrder: async (table, product) => {
    try {
      await pool.query(
        "INSERT INTO transactions (table_number, items_json, total_amount, status) VALUES (?, ?, ?, ?)",
        [table, JSON.stringify(product), 0, "pending"]
      );
    } catch (e) {
      console.error(e);
    }
  },
};
