Các kiến thức đã áp dụng
    1. Sử dụng cả storyboard và code để tạo UI
    2. Phân biệt giữa Frame và Bounds. 
        - Trong hàm layoutSubView(): sử dụng bounds để tính toán contentwidth, còn frame để gán vị trí cho title và icon.
    3. View Drawing Lifecycle
        - Override hàm layoutSubview() vẽ lại UI trong chu kỳ sau theo ý muốn của mình
    4. Kích hoạt vẽ lại giảo diện
        - Sử dụng tableView.beginUpdate()/endUpdate() để hế thống vẽ lại giao diện
Câu hỏi:
    1. Ở hàm layoutSubview() nếu em dùng width lấy từ frame thì nó cũng không có lỗi gì. 
        Vậy những lúc nào thì cần dùng frame, khi nào cần dùng Bounds ngoại trừ việc có animate rotation?
    2. Trong các dự án mà các anh với công ty đang làm thì UI sẽ sử dụng storyboard/xib hay thuần programmatic UI ạ?
