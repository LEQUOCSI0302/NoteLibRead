/*
    Toggle cho phần darkmode chuyển qua chuyển màu sáng và ngược lại
 */
function toggleDarkMode() {
    const body = document.body;
    const btn = document.getElementById("darkModeBtn");
    /*
    check xem css của phần này có class dark-mode chưa nếu chưa thì add vào nếu có rồi thì remove ra
     */
    body.classList.toggle("dark-mode");

    /*
    Kiểm tra trạng thái hiện tại
     */
    const isDarkMode = body.classList.contains("dark-mode");

    btn.textContent = isDarkMode ? '☀️' : '🌙'; /* Nếu đang ở chế độ dark mode thì hiển thị icon mặt trời, ngược lại hiển thị icon mặt trăng */
    localStorage.setItem('theme', isDarkMode ? 'dark' : 'light');

}
    /*
    Load trang kiểm tra local Storage
     */
    document.addEventListener('DOMContentLoaded', function (){
        const saveTheme = localStorage.getItem('theme');
        const btn = document.getElementById("darkModeBtn");

        if(saveTheme==='dark'){
            document.body.classList.add('dark-mode');
            btn.textContent = '☀️';
        }else{
            btn.textContent = '🌙';
        }
    });






/*
    Toggle khi click vào thì nó sẽ show ra danh sách các ngôn ngữ
 */
function toggleLang(){
    document.getElementById("langMenu").classList.toggle('show')/* Check xem đúng id ko rồi sau đó show */
    /* lấy id là chính */
}
/*
thực hành function
 */
    document.addEventListener("click", function(event) {
        if (event.target.closest('.lang-dropdown')) {
            return;
        }
        document.getElementById("langMenu").classList.remove('show');
    });