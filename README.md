# 🏪 POS App – Flutter + Node.js WebSocket + MySQL

Aplikasi **Point of Sale (POS)** modern dengan sistem pemesanan customer–kasir secara realtime menggunakan WebSocket, backend Node.js, dan database MySQL.

---

## 📋 Daftar Isi
- [Fitur Utama](#-fitur-utama)
- [Tech Stack](#-tech-stack)
- [Instalasi](#️-instalasi)
- [Struktur Folder](#-struktur-folder)
- [Cara Kerja](#-cara-kerja)
- [API & WebSocket](#-api--websocket)
- [Database Schema](#-database-schema)
- [Features Highlights](#-features-highlights)
- [Troubleshooting](#️-troubleshooting)
- [Kontributor](#-kontributor)

---

## 🚀 Fitur Utama

### 👤 Customer App
- ✅ Registrasi dan login per meja
- ✅ Browsing menu (appetizer, main course, dessert, minuman)
- ✅ Menambah/mengurangi item ke keranjang
- ✅ Mengirim pesanan ke kasir secara realtime
- ✅ Tracking status pesanan (menunggu → diproses → selesai)
- ✅ Memberikan rating produk (1-5 bintang + komentar)

### 💼 Kasir / Admin
- ✅ Dashboard realtime untuk semua pesanan dari meja
- ✅ Update status pesanan secara instant
- ✅ Manajemen Produk (Create, Read, Update, Delete)
- ✅ Manajemen User/Karyawan (Create, Read, Update, Delete)
- ✅ Sistem stok otomatis (berkurang saat pesanan selesai)
- ✅ Laporan lengkap:
  - Produk terlaris
  - Produk stok rendah
  - Total produk dan karyawan
  - Riwayat penjualan
- ✅ Export laporan PDF
- ✅ Kirim email nota pembelian

### 🔌 Backend – Node.js WebSocket Server
- ✅ Realtime communication antara customer dan kasir
- ✅ Broadcast update ke semua client
- ✅ Manajemen transaksi di MySQL
- ✅ Sistem stok otomatis
- ✅ Tracking status per meja

---

## 💻 Tech Stack

**Frontend:**
- Flutter (Dart)
- Provider (state management)
- http package (API requests)
- SharedPreferences (local storage)
- package:pdf & package:printing (PDF generation)
- mailer package (email)

**Backend:**
- Node.js
- WebSocket (ws package)
- Express.js (optional, untuk REST API)
- MySQL2 (database driver)

**Database:**
- MySQL 5.7+

**Tools:**
- Git
- Android Studio / Xcode / VS Code

---

## 📁 Struktur Folder

```
project-root/
│
├── app/                          # Flutter Application
│   └── lib/
│       ├── core/
│       │   └── services/         # API & Business Logic
│       │       ├── api_services.dart
│       │       ├── auth_services.dart
│       │       ├── dashboard_service.dart
│       │       ├── product_service.dart
│       │       ├── rating_service.dart
│       │       └── user_service.dart
│       │
│       ├── models/               # Data Models
│       │   ├── item.dart
│       │   ├── menu_appetizer.dart
│       │   ├── menu_dessert.dart
│       │   ├── menu_maincourse.dart
│       │   ├── menu_minuman.dart
│       │   ├── product.dart
│       │   ├── rating.dart
│       │   ├── sales_record.dart
│       │   ├── table_order.dart
│       │   └── user.dart
│       │
│       ├── providers/            # State Management
│       │   └── auth_providers.dart
│       │
│       ├── screens/              # UI Screens
│       │   ├── admin/
│       │   │   ├── dashboard_screen.dart
│       │   │   ├── edit_product_screen.dart
│       │   │   ├── edit_user_screen.dart
│       │   │   ├── manage_products_screen.dart
│       │   │   ├── manage_users_screen.dart
│       │   │   └── view_reports_screen.dart
│       │   │
│       │   ├── auth/
│       │   │   ├── login_screen.dart
│       │   │   ├── reset_password_screen.dart
│       │   │   └── sign_up_screen.dart
│       │   │
│       │   ├── cashier/
│       │   │   └── order_page.dart
│       │   │
│       │   └── customer/
│       │       ├── menu/
│       │       │   ├── body.dart
│       │       │   └── menu_screen.dart
│       │       ├── customer_form_screen.dart
│       │       ├── customer_screen.dart
│       │       ├── home_screen.dart
│       │       ├── order_screen.dart
│       │       ├── profile_screen.dart
│       │       ├── rating_screen.dart
│       │       └── splash_screen.dart
│       │
│       ├── theme/
│       │   └── app_theme.dart
│       │
│       ├── utils/
│       │   ├── email_sender.dart
│       │   ├── format_currency.dart
│       │   ├── pdf_report.dart
│       │   └── receipt_email.dart
│       │
│       └── widgets/
│           ├── action_button.dart
│           ├── dashboard_card.dart
│           ├── item_row.dart
│           └── order_summary.dart
│
├── backend/                      # Node.js Backend
│   ├── server.js                 # WebSocket Server
│   ├── package.json
│   ├── .env                      # Environment Variables
│   └── database/
│       └── schema.sql            # Database Structure
│
└── README.md
```

---

## ⚙️ Instalasi

### Prerequisites
Pastikan sudah install:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.0+)
- [Node.js](https://nodejs.org/) (v14+)
- [MySQL Server](https://www.mysql.com/downloads/) (v5.7+)
- Git

### 1. Clone Repository
```bash
git clone https://github.com/yourusername/pos-app.git
cd pos-app
```

### 2. Setup Backend (Node.js WebSocket Server)
```bash
cd backend
npm install
```

Buat file `.env`:
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=pos_database
WS_PORT=8080
```

Jalankan server:
```bash
node server.js
```

Output:
```
WebSocket Server running on ws://0.0.0.0:8080
```

### 3. Setup Database (MySQL)
```bash
mysql -u root -p < backend/database/schema.sql
```

### 4. Setup Frontend (Flutter)
```bash
cd app
flutter pub get
```

Update konfigurasi API di `lib/core/services/api_services.dart`:
```dart
const String API_URL = 'http://your-ip:3000';
const String WS_URL = 'ws://your-ip:8080';
```

Jalankan aplikasi:
```bash
flutter run
```

---

## 🔄 Cara Kerja

### Customer → Kasir (Order Flow)
1. Customer login dengan nomor meja
2. Customer browsing menu dan menambah ke keranjang
3. Customer kirim pesanan → Flutter mengirim WebSocket message:
   ```json
   {
     "type": "cart_update",
     "table_number": 5,
     "customer_name": "Budi",
     "items": [
       { "name": "Nasi Goreng", "quantity": 2, "price": 15000 }
     ],
     "total": 30000
   }
   ```
4. Server menerima → simpan ke MySQL → broadcast ke kasir
5. Kasir melihat order realtime di dashboard
6. Kasir ubah status pesanan (diproses → selesai)
7. Customer melihat status update realtime

### Kasir → System (Status Update)
1. Kasir klik "Selesai" untuk pesanan
2. Server kirim pesan:
   ```json
   {
     "type": "status_update",
     "table_number": 5,
     "status": "selesai"
   }
   ```
3. Server update MySQL dan kurangi stok produk
4. Broadcast ke semua client (customer + kasir)
5. Customer melihat pesanan sudah siap

---

## 🔌 API & WebSocket

### WebSocket Events
| Event | Direction | Payload |
|-------|-----------|---------|
| `cart_update` | Customer → Server | Order items & total |
| `status_update` | Kasir → Server | Table number & status |
| `broadcast_update` | Server → All | Updated order info |
| `stok_update` | Server → Kasir | Product stock info |

---

## 📊 Database Schema

### Tabel Utama
- **products**: Master produk (nama, harga, stok, kategori)
- **users**: Data karyawan (nama, email, role, password)
- **orders**: Transaksi (nomor meja, total, timestamp, status)
- **order_items**: Detail item per transaksi
- **ratings**: Rating produk dari customer
- **sales_records**: Histori penjualan untuk laporan

---

## 🎨 Features Highlights

### 📄 Export PDF Laporan
Kasir bisa export laporan berisi:
- Total penjualan harian/bulanan
- Produk terlaris
- Produk stok rendah
- Daftar karyawan

Menggunakan package `pdf` dan `printing`.

### 📧 Email Nota Pembelian
Setelah transaksi selesai, nota otomatis dikirim ke email customer:
- Daftar item pesanan
- Total harga
- Waktu pembelian
- Nomor meja & nomor order

### ⭐ Rating System
Customer bisa memberikan rating (1-5 bintang) + komentar untuk setiap produk. Admin bisa lihat di dashboard.

### 🔐 Autentikasi
- Customer login dengan nomor meja
- Kasir/Admin login dengan email & password
- Session disimpan di SharedPreferences

---

## 🛠️ Troubleshooting

| Masalah | Solusi |
|---------|--------|
| WebSocket connection refused | Pastikan server running dan IP benar di client |
| Database connection error | Check DB credentials di `.env` |
| Flutter dependencies error | Jalankan `flutter clean && flutter pub get` |
| Port 8080 already in use | Ubah port di `server.js` dan client config |

---

## 👨‍💻 Kontributor

| No | Nama Lengkap | Email | GitHub Username |
| -- | ------------ | ----- | --------------- |
| 1  | **Bima Adji Kusuma** | [bimaadjikusuma@gmail.com](mailto:bimaadjikusuma@gmail.com) | [@bimadji](https://github.com/bimadji) |
| 2  | **Ivan Adrian Bhagaskara** | [email2@example.com](mailto:Muhammadizzanarendra2736@gmail.com) | [@mizarendra](https://github.com/mizarendra) |
| 3  | **Muhammad Izza Narendra** | [email3@example.com](mailto:Muhammadizzanarendra2736@gmail.com) | [@mizarendra](https://github.com/mizarendra) |
| 4  | **Muhamad Prabaswara Martana** | [email4@example.com](mailto:prbswrmrtana@gmail.com) | [@prbswrmrtana_boop](https://github.com/prbswrmrtana_boop) |

---
