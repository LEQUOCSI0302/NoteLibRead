# NoteLibRead
Đây là web dựa vào người dùng là chính, cho người dùng cá nhân thao tác vào web, cộng đồng chỉ là phụ. Người dùng lưu trữ phim, anime, manwa,manhua, donghua,manga, movie.
- ACGN là tên gọi tóm tắt của lại trên.
# Chức năng chính
- Trên thanh công cụ sẽ chứa: Cá nhân, Cộng đồng, Bảng xếp hạng,Thư, (Logo để Login hoặc Register)
## Ở phần Cá nhân:
- Tìm kiếm
- Người dùng sẽ lưu trữ những dữ liệu họ xem thành 1 danh sách bao gồm:
+ Ảnh của ACGN
+ Tên bộ ACGN
+ Tác giả ACGN
+ Thể loại ACGN
+ Ngày đọc
+ Nội dung ACGN
+ Sao đánh giá
+ Ngày sáng tác của tác phẩm
## Ở phần công đồng
- Tìm kếm
- Lọc
- Hiển thị các bài mới nhất
- Comment
- Đánh giá
- Chia sẻ cho bạn bè
## Bảng xếp hạng
- Lọc
- Hiển thị danh sách
## Thư
- THông báo đánh giá
- Admin thông báo người dùng
## Avatar
- Login và Register
- nếu đăng ký thành công thì hiển thị avt người đăng nhập
## Lô trình 
Giai đoạn 1 — Nền tảng (1-2 tuần)
├── Cài môi trường
├── Hiểu Maven, Spring Boot là gì
└── Tạo project đầu tiên chạy được "Hello World"

Giai đoạn 2 — Database (1 tuần)
├── Học SQL cơ bản (SELECT, INSERT, UPDATE, DELETE)
├── Tạo database MySQL cho project
└── Kết nối Spring Boot với MySQL qua JPA

Giai đoạn 3 — CRUD cá nhân (2 tuần)
├── Tạo bảng list_items
├── Làm form thêm/sửa/xóa mục
└── Hiển thị danh sách, tìm kiếm, lọc

Giai đoạn 4 — Auth (1-2 tuần)
├── Đăng ký / Đăng nhập
├── Spring Security + Session
└── Mỗi user chỉ thấy list của mình

Giai đoạn 5 — Community (2 tuần)
├── Đăng bài public
├── Comment, like
└── Feed bài của mọi người

Giai đoạn 6 — Group Chat (2 tuần)
├── Tạo/tham gia group
├── Nhắn tin realtime (WebSocket)
└── Hiển thị tin nhắn

Giai đoạn 7 — Hoàn thiện & Deploy
├── Giao diện đẹp hơn (Bootstrap)
├── Test kỹ
└── Deploy lên Railway (free)
## Bước 1 — Cài đặt công cụ
| Công cụ | Link | Mục đích |
| :—– | :———- | :————– |
| JDK 17| Dadoptium.net | Chạy Java |
| IntelliJ IDEA Community | jetbrains.com| IDE miễn phí |
| MySQL 8 | dev.mysql.com | Database |
| MySQL Workbench | Cài kèm MySQL | Quản lý DB bằng UI |
## Bước 2 — Tạo project Spring Boot
Project   : Maven
Language  : Java
Version   : Spring Boot 3.x
Packaging : Jar
Java      : 21

Dependencies cần thêm:
  ✅ Spring Web
  ✅ Thymeleaf
  ✅ Spring Data JPA
  ✅ MySQL Driver
  ✅ Lombok
## Bước 3 — Chạy thử "Hello World"
``` // src/main/java/.../controller/HomeController.java
@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "index"; // trỏ đến file templates/index.html
    }
}
```
<!-- src/main/resources/templates/index.html -->
<!DOCTYPE html>
<html>
<head><title>Media Notes</title></head>
<body>
    <h1>Chào mừng đến Media Notes! 🎬</h1>
</body>
</html>
Nhấn Run → mở trình duyệt vào http://localhost:8080 → thấy chữ là thành công!
## Bước 4 - Nghiên cứu đối thủ NGAY BÂY GIỜ

