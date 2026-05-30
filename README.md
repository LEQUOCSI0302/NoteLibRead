# NoteLibRead
- Là nền tảng website hướng tới trải nghiệm cá nhân là chính, cho phép người dùng lưu trữ, quản lý và ghi chép lại quá trình xem/ đọc các thể lại **ACGN** (Anime, Comic/Manga/Manhua/Manhwa, Game, Novel/Movie/Donghua). Bên cạnh đó, hệ thống tích hợp các tính năng cộng đồng phụ để kết nối những người có cùng sở thích.
- ---
## 🚀 Chức năng chính
### 👤 1. Phân hệ Cá nhân (Trọng tâm)
* **Tìm kiếm & Bộ lọc:** Tìm kiếm nhanh trong danh sách lưu trữ cá nhân.
* **Quản lý danh sách ACGN (CRUD):** Lưu trữ thông tin chi tiết bao gồm:
  * Ảnh bìa tác phẩm
  * Tên bộ ACGN
  * Tác giả & Ngày sáng tác
  * Thể loại (Tag)
  * Ngày đọc/xem gần nhất
  * Nội dung tóm tắt / Ghi chú cá nhân
  * Đánh giá số sao (Rating)

### 👥 2. Phân hệ Cộng đồng (Phụ)
* Tìm kiếm và lọc các bài viết chia sẻ từ người dùng khác.
* Hiển thị danh sách các bài viết, đánh giá mới nhất.
* Tương tác: Bình luận (Comment), Đánh giá (Review) và Chia sẻ cho bạn bè.

### 📊 3. Bảng xếp hạng & Hệ thống Thư
* **Bảng xếp hạng:** Lọc và hiển thị danh sách các bộ ACGN được yêu thích nhất hệ thống.
* **Hộp thư (Notification):** * Nhận thông báo khi có tương tác/đánh giá mới.
  * Nhận thông báo từ Quản trị viên (Admin).

### 🔐 4. Tài khoản & Khách viếng thăm
* Hỗ trợ Đăng ký (Register) & Đăng nhập (Login).
* Sau khi đăng nhập thành công, hiển thị Avatar người dùng trên thanh điều hướng (Navbar).

---
## 🗺️ Lộ trình phát triển (Project Roadmap)
> 💡 **Mẹo:** Các mục bên dưới là danh sách công việc (Task List). Khi hoàn thành mục nào, bạn có thể đánh dấu `[x]` để theo dõi tiến độ trực tiếp trên GitHub!

### 🎯 Giai đoạn 1 — Nền tảng (1-2 tuần)
- [x] Cài đặt môi trường phát triển (JDK 25, MySQL, IntelliJ IDEA).
- [x] Tìm hiểu kiến thức nền tảng về Maven và Spring Boot.
- [ ] Tạo project đầu tiên và chạy thử nghiệm "Hello World".

### 🗄️ Giai đoạn 2 — Database (1 tuần)
- [ ] Học và thực hành SQL cơ bản (`SELECT`, `INSERT`, `UPDATE`, `DELETE`).
- [ ] Thiết kế và tạo database MySQL cho project.
- [ ] Cấu hình kết nối Spring Boot với MySQL thông qua Spring Data JPA.

### 📝 Giai đoạn 3 — CRUD Cá Nhân (2 tuần)
- [ ] Thiết kế bảng dữ liệu `list_items`.
- [ ] Xây dựng giao diện/API cho form Thêm / Sửa / Xóa mục công việc.
- [ ] Làm tính năng hiển thị danh sách, tìm kiếm và lọc dữ liệu.

### 🔐 Giai đoạn 4 — Auth & Phân Quyền (1-2 tuần)
- [ ] Xây dựng tính năng Đăng ký / Đăng nhập.
- [ ] Tích hợp **Spring Security** & Session/JWT để bảo mật.
- [ ] Phân quyền dữ liệu: Mỗi user chỉ có quyền xem/quản lý list cá nhân của mình.

### 🌐 Giai đoạn 5 — Community (2 tuần)
- [ ] Phát triển tính năng đăng bài viết ở chế độ công khai (Public).
- [ ] Làm tính năng Tương tác: Bình luận (Comment) và Thích (Like).
- [ ] Xây dựng trang bảng tin (Feed) tổng hợp bài viết từ mọi người.

### 💬 Giai đoạn 6 — Group Chat (2 tuần)
- [ ] Thiết kế tính năng Tạo nhóm và Tham gia nhóm chat.
- [ ] Xây dựng cơ chế nhắn tin thời gian thực (Realtime messaging) sử dụng **WebSocket**.
- [ ] Xử lý lưu trữ và hiển thị lịch sử tin nhắn trong nhóm.

### 🚀 Giai đoạn 7 — Hoàn thiện & Deploy
- [ ] Tối ưu hóa giao diện người dùng đẹp và responsive hơn với **Bootstrap** (hoặc Tailwind CSS).
- [ ] Tiến hành kiểm thử kỹ lưỡng (Unit Test / Integration Test) để tìm và sửa lỗi.
- [ ] Triển khai ứng dụng (Deploy) lên nền tảng **Railway** (hoặc các dịch vụ Cloud tương đương).
## 🛠️ Hướng dẫn cài đặt & Khởi chạy nhanh
### Bước 1 — Chuẩn bị công cụ
| Công cụ                 | Link | Mục đích |
|:------------------------| :--- | :--- |
| JDK 25                  | [adoptium.net](https://adoptium.net) | Chạy Java |
| IntelliJ IDEA Community | [jetbrains.com](https://jetbrains.com) | IDE miễn phí |
| MySQL 9.5.0             | [dev.mysql.com](https://dev.mysql.com) | Database |
| MySQL Workbench         | Cài kèm MySQL | Quản lý DB bằng UI |
### Bước 2 — Cấu hình Project Spring Boot
- Project   : Maven
- Language  : Java
- Version   : Spring Boot 4.0.6
- Packaging : Jar
- Java      : 25

Dependencies cần thêm:
  - ✅ Spring Web
  - ✅ Thymeleaf
 -  ✅ Spring Data JPA
 -  ✅ MySQL Driver
 -  ✅ Lombok
### Bước 3 — Chạy thử nghiệm "Hello World"
``` // src/main/java/.../controller/HomeController.java
@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "index"; // trỏ đến file templates/index.html
    }
}
```
```
<!-- src/main/resources/templates/index.html -->
<!DOCTYPE html>
<html>
<head><title>Media Notes</title></head>
<body>
    <h1>Chào mừng đến Media Notes! 🎬</h1>
</body>
</html>
```
>Nhấn Run → mở trình duyệt vào http://localhost:8080 → thấy chữ là thành công!

