## BookLibrary - những gì em đã làm được

* BookLibrary là một app iOS nhỏ để tìm kiếm sách, xem thông tin sách và lưu những cuốn mình quan tâm vào thư viện cá nhân.

* Trong project này em đã làm được các phần chính sau:

- Tạo app bằng UIKit, dùng nhiều màn hình riêng như Explore, Search, Library, Stats và Detail.
- Làm tab bar chính cho app, có các tab để khám phá sách, tìm kiếm, xem thư viện và xem thống kê.
- Kết nối API của OpenLibrary để tìm sách theo từ khóa.
- Hiển thị danh sách sách bằng UICollectionView, dùng layout khác nhau cho từng màn hình.
- Làm màn hình tìm kiếm có debounce, nghĩa là người dùng gõ xong một chút app mới gọi API, tránh gọi quá nhiều lần.
- Làm màn hình chi tiết sách, có ảnh bìa, tên sách, tác giả, năm xuất bản và nút lưu sách.
- Lưu sách vào máy bằng Core Data để lần sau mở app vẫn còn dữ liệu.
- Làm màn hình Library để xem các sách đã lưu.
- Cho phép đổi trạng thái sách: Want To Read, Reading, Read.
- Làm màn hình chi tiết sách đã lưu để sửa note, rating và trạng thái đọc.
- Làm màn hình Stats để đếm số sách theo từng trạng thái.
- Dùng Combine để bind dữ liệu từ ViewModel sang ViewController.
- Tách code theo hướng MVVM đơn giản: ViewController lo UI, ViewModel lo state/logic, Repository lo lấy dữ liệu từ API hoặc Core Data.
- Có custom cell, custom search bar, helper load ảnh bìa sách và cache ảnh để UI mượt hơn.

* Hiện tại app đã có luồng cơ bản của một thư viện sách cá nhân: tìm sách, xem chi tiết, lưu vào thư viện, cập nhật trạng thái/note/rating và xem thống kê. Phần thêm sách thủ công đã có màn hình được mở từ nút cộng ở giữa tab bar, nhưng chức năng bên trong vẫn chưa triển khai.
