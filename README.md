# 📚 NoteLibRead

Nền tảng web hướng tới trải nghiệm **cá nhân** là chính, cho phép người dùng lưu trữ, quản lý và ghi chép lại quá trình xem/đọc các thể loại **ACGN** (Anime, Comic/Manga/Manhua/Manhwa, Game, Novel/Movie/Donghua). Bên cạnh đó, hệ thống tích hợp các tính năng cộng đồng phụ để kết nối những người có cùng sở thích.

---

## 🧰 Công nghệ sử dụng

| Thành phần | Phiên bản |
|:--|:--|
| Java | 21 |
| Spring Boot | 3.4.0 |
| Build tool | Maven |
| Database | MySQL 8.0+ |
| Migration | Flyway (`flyway-core` + `flyway-mysql`) |
| ORM | Spring Data JPA / Hibernate |
| Template engine | Thymeleaf |
| Bảo mật | Spring Security + JWT (`jjwt`) |
| Khác | Lombok |

> ⚠️ Project **không** dùng `spring.jpa.hibernate.ddl-auto=update/create`. Toàn bộ schema (bảng, trigger, event) được quản lý bằng **Flyway migration script**, Hibernate chỉ dùng để đọc/ghi dữ liệu (`ddl-auto=none`).

---

## 🚀 Chức năng chính

### 👤 1. Phân hệ Cá nhân (Trọng tâm)
- **Tìm kiếm & Bộ lọc:** Tìm kiếm nhanh trong danh sách lưu trữ cá nhân.
- **Quản lý danh sách ACGN (CRUD):** Lưu trữ thông tin chi tiết bao gồm:
  - Ảnh bìa tác phẩm
  - Tên bộ ACGN
  - Tác giả & Ngày sáng tác
  - Thể loại (Tag)
  - Ngày đọc/xem gần nhất
  - Nội dung tóm tắt / Ghi chú cá nhân
  - Đánh giá số sao (Rating)

### 👥 2. Phân hệ Cộng đồng (Phụ)
- Tìm kiếm và lọc các bài viết chia sẻ từ người dùng khác.
- Hiển thị danh sách các bài viết, đánh giá mới nhất.
- Tương tác: Bình luận (Comment), Đánh giá (Review) và Chia sẻ cho bạn bè.

### 📊 3. Bảng xếp hạng & Hệ thống Thư
- **Bảng xếp hạng:** Lọc và hiển thị danh sách các bộ ACGN được yêu thích nhất hệ thống.
- **Hộp thư (Notification):**
  - Nhận thông báo khi có tương tác/đánh giá mới.
  - Nhận thông báo từ Quản trị viên (Admin).

### 🔐 4. Tài khoản & Khách viếng thăm
- Hỗ trợ Đăng ký (Register) & Đăng nhập (Login).
- Sau khi đăng nhập thành công, hiển thị Avatar người dùng trên thanh điều hướng (Navbar).

---

## 🛠️ Hướng dẫn cài đặt & khởi chạy

### Bước 1 — Chuẩn bị công cụ

| Công cụ | Link | Ghi chú |
|:--|:--|:--|
| JDK 21 | [adoptium.net](https://adoptium.net) | Bắt buộc đúng bản 21 (project build bằng Java 21) |
| MySQL 8.0+ | [dev.mysql.com](https://dev.mysql.com) | 8.0 trở lên, khuyến nghị 8.0 hoặc 8.4 LTS |
| IntelliJ IDEA (hoặc IDE bất kỳ) | [jetbrains.com](https://jetbrains.com) | Không bắt buộc |
| MySQL Workbench / DBeaver | tuỳ chọn | Quản lý DB bằng UI |

### Bước 2 — Clone project

```bash
git clone https://github.com/LEQUOCSI0302/NoteLibRead.git
cd NoteLibRead
```

### Bước 3 — Cấu hình kết nối MySQL

Mở file `src/main/resources/application.properties` và chỉnh lại **username/password** MySQL của máy bạn:

```properties
spring.application.name=NoteLibs

spring.datasource.url=jdbc:mysql://localhost:3306/note_lib_read?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=your_password

# Hibernate KHÔNG tự tạo/sửa bảng — schema do Flyway quản lý
spring.jpa.hibernate.ddl-auto=none

spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration
spring.flyway.baseline-on-migrate=true
```

> 💡 **Không cần tạo database `note_lib_read` trước.** Migration `V1__init_schema.sql` đã có sẵn lệnh `CREATE DATABASE IF NOT EXISTS note_lib_read` và tự `USE` vào database đó, Flyway sẽ tự tạo khi chạy lần đầu.
>
> Nếu bạn **đã lỡ tạo sẵn** database `note_lib_read` trước đó (rỗng, chưa có bảng nào) thì vẫn chạy bình thường — vì migration dùng `IF NOT EXISTS` nên sẽ không báo lỗi "database exists".

### Bước 4 — Chạy migration & khởi động ứng dụng

Không cần chạy Flyway tách riêng — Spring Boot sẽ **tự động migrate khi ứng dụng khởi động** (`spring.flyway.enabled=true`).

Chạy bằng Maven Wrapper:

```bash
# macOS / Linux
./mvnw spring-boot:run

# Windows
mvnw.cmd spring-boot:run
```

Hoặc chạy trực tiếp class `NoteLibsApplication` từ IDE.

Khi khởi động thành công, log sẽ hiển thị Flyway migrate qua từng version:

```
Migrating schema `note_lib_read` to version "1 - init schema"
Migrating schema `note_lib_read` to version "2 - init triggers"
Migrating schema `note_lib_read` to version "3 - init events"
Successfully applied 3 migrations
```

Truy cập: **http://localhost:8080**

---

## 🗃️ Quản lý Database bằng Flyway

Toàn bộ schema nằm tại `src/main/resources/db/migration/`, đặt tên theo chuẩn Flyway `V{version}__{mô_tả}.sql`:

| File | Nội dung |
|:--|:--|
| `V1__init_schema.sql` | Tạo database + toàn bộ bảng (users, works, authors, genres, ratings, comments...) |
| `V2__init_triggers.sql` | Trigger đồng bộ dữ liệu (VD: cache `avg_rating`, `avatar_url`...) |
| `V3__init_events.sql` | MySQL Event Scheduler (tác vụ chạy định kỳ) |

Flyway lưu lịch sử migration trong bảng `flyway_schema_history` — **không tự sửa tay** các file migration đã chạy (đã apply), vì Flyway sẽ báo lỗi checksum không khớp.

### Thêm thay đổi schema mới

1. Tạo file mới, tăng version tiếp theo, ví dụ:
   ```
   V4__add_column_something.sql
   ```
2. Viết SQL thay đổi (KHÔNG sửa lại các file `V1`, `V2`, `V3` đã tồn tại).
3. Chạy lại ứng dụng — Flyway tự phát hiện và áp dụng migration mới.

### Một số lệnh Flyway hữu ích (qua Maven plugin, nếu cần chạy tay)

```bash
./mvnw flyway:info      # Xem trạng thái các migration
./mvnw flyway:migrate   # Chạy migration thủ công
./mvnw flyway:repair    # Sửa lịch sử migration khi bị lỗi checksum
```

> ⚠️ **Lưu ý quan trọng:** Vì Event Scheduler được dùng trong `V3__init_events.sql`, cần bật event scheduler ở MySQL server (thường mặc định đã bật ở MySQL 8+). Kiểm tra bằng:
> ```sql
> SHOW VARIABLES LIKE 'event_scheduler';
> -- Nếu là OFF, bật bằng:
> SET GLOBAL event_scheduler = ON;
> ```

---

## ❓ Xử lý lỗi thường gặp

| Lỗi | Nguyên nhân | Cách xử lý |
|:--|:--|:--|
| `Can't create database 'note_lib_read'; database exists` | Database đã tồn tại nhưng có bảng lạ, không khớp với migration | Xoá database cũ rồi chạy lại (`DROP DATABASE note_lib_read;`), hoặc dùng `flyway:repair` nếu chỉ lệch checksum |
| `Access denied for user 'root'@'localhost'` | Sai username/password trong `application.properties` | Kiểm tra lại thông tin đăng nhập MySQL |
| `Communications link failure` | MySQL server chưa chạy, hoặc sai port | Kiểm tra MySQL service đang chạy ở port `3306` |
| `Validate failed: Migrations have failed validation` | File migration đã apply bị sửa nội dung | Không sửa file migration cũ — tạo file version mới thay vào |

---

## 📁 Cấu trúc thư mục chính

```
src/main/java/com/app/NoteLibs/
├── config/            # Cấu hình Spring (Security, ...)
├── model/             # JPA Entity (ánh xạ bảng DB)
├── embeddable/        # Composite key cho bảng nhiều-nhiều
├── enums/             # Enum dùng chung (UserRole, WorkStatus, ...)
├── controller/        # REST/MVC Controller
├── dto/               # Data Transfer Object
├── repository/        # Spring Data JPA Repository
├── service/           # Business logic
├── exception/         # Xử lý ngoại lệ
└── util/              # Tiện ích dùng chung

src/main/resources/
├── db/migration/      # Flyway migration scripts (V1, V2, V3, ...)
├── static/            # CSS/JS/ảnh tĩnh
├── templates/         # Giao diện Thymeleaf
└── application.properties
```
