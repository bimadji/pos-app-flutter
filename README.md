# 📦 POS App – Flutter + Node.js Realtime WebSocket + MySQL

Aplikasi Point of Sale (POS) modern dengan sistem pemesanan customer–kasir secara realtime menggunakan WebSocket, backend Node.js, dan database MySQL.

Aplikasi ini mendukung:

Customer order dari device masing-masing

Kasir menerima update pesanan realtime

Manajemen produk, user, rating, dan laporan

Generate PDF laporan + email nota

Autentikasi login

🚀 Fitur Utama
👤 Customer App

Registrasi + login meja

Melihat menu (appetizer, main course, dessert, minuman)

Menambah item ke keranjang

Mengirim pesanan ke kasir realtime

Melihat status pesanan (menunggu → diproses → selesai)

Memberikan rating produk

💼 Kasir / Admin

Melihat pesanan realtime semua meja

Mengubah status pesanan

Stok otomatis berkurang saat pesanan selesai

CRUD Produk

CRUD User (karyawan)

Melihat laporan:

Produk terlaris

Produk stok rendah

Total produk

Total karyawan

Export laporan PDF

Kirim email nota pembelian

🔌 Backend – Node.js WebSocket Server

Realtime communication (customer ↔ kasir)

Menyimpan transaksi ke MySQL

Mengurangi stok otomatis saat pesanan selesai

Menyimpan status per meja

Broadcast ke semua client

📁 Struktur Folder (ringkas)
app/lib
│
├── core/
│   └── services/
│       ├── api_services.dart
│       ├── auth_services.dart
│       ├── dashboard_service.dart
│       ├── product_service.dart
│       ├── rating_service.dart
│       └── user_service.dart
│
├── models/
│   ├── item.dart
│   ├── menu_appetizer.dart
│   ├── menu_dessert.dart
│   ├── menu_maincourse.dart
│   ├── menu_minuman.dart
│   ├── product.dart
│   ├── rating.dart
│   ├── sales_record.dart
│   ├── table_order.dart
│   └── user.dart
│
├── providers/
│   └── auth_providers.dart
│
├── screens/
│   ├── admin/
│   │   ├── dashboard_screen.dart
│   │   ├── edit_product_screen.dart
│   │   ├── edit_user_screen.dart
│   │   ├── manage_products_screen.dart
│   │   ├── manage_users_screen.dart
│   │   └── view_reports_screen.dart
│   │
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── reset_password_screen.dart
│   │   └── sign_up_screen.dart
│   │
│   ├── cashier/
│   │   └── order_page.dart
│   │
│   └── customer/
│       ├── menu/
│       │   ├── body.dart
│       │   └── menu_screen.dart
│       ├── customer_form_screen.dart
│       ├── customer_screen.dart
│       ├── home_screen.dart
│       ├── order_screen.dart
│       ├── profile_screen.dart
│       ├── rating_screen.dart
│       └── splash_screen.dart
│
├── theme/
│   └── app_theme.dart
│
├── utils/
│   ├── email_sender.dart
│   ├── format_currency.dart
│   ├── pdf_report.dart
│   └── receipt_email.dart
│
└── widgets/
├── action_button.dart
├── dashboard_card.dart
├── item_row.dart
└── order_summary.dart

⚙️ Arsitektur Singkat

Flutter sebagai client (customer + kasir)

Node.js WebSocket Server untuk realtime komunikasi

MySQL untuk penyimpanan data:

produk

transaksi

user

rating

stok

Data aplikasi di-cache lokal menggunakan SharedPreferences:

table_number

customer_name

login session

🔌 Instalasi Backend – WebSocket Server
1. Install dependencies
   npm install ws mysql2

2. Jalankan server
   node server.js


Server berjalan di:

ws://0.0.0.0:8080

📱 Instalasi Flutter
1. Install dependencies
   flutter pub get

2. Jalankan aplikasi
   flutter run

🔄 Cara Kerja Realtime (berdasarkan server.js)
Customer → Kasir

Customer menambah item ke cart

Flutter mengirim pesan:

{
"type": "cart_update",
"table_number": 5,
"customer_name": "Budi",
"items": [...],
"total": 32000
}


Server:

simpan transaksi ke MySQL

update memory transactions{}

broadcast ke semua client

Kasir → Customer

Kasir ubah status meja:

{
"type": "status_update",
"table_number": 5,
"status": "diproses"
}


Server:

update status meja di MySQL

jika selesai → kurangi stok

broadcast ke semua client

📄 Laporan dan PDF

Fitur export PDF:

total produk

stok rendah

produk terlaris

produk paling sedikit terjual

dan riwayat penjualan

PDF menggunakan:

package:pdf
package:printing

⭐ Rating System

Customer dapat memberikan:

bintang (1–5)

komentar

nama customer

nomor meja

Admin dapat melihat:

daftar rating

sorting berdasarkan tanggal

📬 Email Nota

Nota transaksi dikirim via email setelah transaksi selesai:

list item

total harga

waktu pembelian

detail meja

nomor order

✔️ Kesimpulan

Proyek ini adalah aplikasi POS lengkap dengan:

Flutter frontend (customer + kasir)

Node.js WebSocket backend (realtime)

MySQL database

Manajemen data lengkap

PDF laporan

Email nota

Rating system
