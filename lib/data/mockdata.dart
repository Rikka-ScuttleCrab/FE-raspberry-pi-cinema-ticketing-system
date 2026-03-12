import '../models/film.dart';
import '../models/category.dart';
import '../models/ticket_type.dart';

final List<TicketType> defaultTickets = [
  TicketType(id: 1, name: 'Thường', price: 70000),
  TicketType(id: 2, name: '3D', price: 150000),
  TicketType(id: 3, name: 'IMAX', price: 195000),
];

final List<Category> defaultCategories = [
  Category(id: 0, name: 'Hành Động', description: ''),
  Category(id: 1, name: 'Hoạt Hình', description: ''),
  Category(id: 2, name: 'Kinh Dị', description: ''),
  Category(id: 3, name: 'Tâm Lý', description: ''),
  Category(id: 4, name: 'Giả Tưởng', description: ''),
  Category(id: 5, name: 'Tội Phạm', description: ''),
  Category(id: 6, name: 'Giật Gân', description: ''),
  Category(id: 7, name: 'Phiêu Lưu', description: ''),
];

final List<Film> mockFilms = [
  Film(
    id: 1,
    name: 'Bố Già Trở Lại',
    categories: [defaultCategories[0]],
    posterImageURL: 'https://cdn.galaxycine.vn/media/2026/1/16/bo-gia-tro-lai-500_1768535842789.jpg',
    duration: '95 phút',
    description: 'Bộ phim kể về ông Đằng, một trinh sát ngầm tưởng chừng được khép lại quá khứ đầy máu lửa – buộc phải dấn thân vào một cuộc chiến khốc liệt khi con gái ông, Yến, bất ngờ bị bắt cóc. Cuộc giải cứu con gái không chỉ là một hành trình đầy kịch tính, kết hợp giữa yếu tố hành động chống lại cái ác một cách không khoan nhượng mà còn là một hành trình hàn gắn tình cảm gia đình của ông sau những rạn nứt, đổ vỡ.',
    tickets: [defaultTickets[0]],
  ),
  Film(
    id: 2,
    name: 'Tiểu Yêu Quái Núi Lãng Lãng',
    categories: [defaultCategories[1]],
    posterImageURL: 'https://cdn.galaxycine.vn/media/2026/1/13/nobody-500_1768273580665.jpg',
    duration: '118 phút',
    description: 'Giữa thế đạo mà "kẻ mạnh làm vua", một nhóm tiểu yêu quái vô danh và tầm thường gồm Heo, Ếch, Chồn và Khỉ Đột vốn chỉ quen bị bắt nạt và xua đuổi, đã quyết tâm hợp lực thay đổi số phận. Chúng quyết định thực hiện một phen đánh cược điên rồ khi giả danh đoàn thỉnh kinh, vượt vạn dặm tới Tây Thiên để cầu xin Phật Tổ sự bất tử và vang danh. Hành trình hài hước và đầy tính nhân văn đã chinh phục trái tim người xem, đưa “Tiểu yêu quái núi Lãng Lãng” trở thành tác phẩm phim hoạt hình 2D đạt doanh thu cao nhất Trung Quốc mọi thời đại.',
    tickets: [defaultTickets[0]],
  ),
  Film(
    id: 3,
    name: 'Đồi Câm Lặng: Ác Mộng Trong Sương',
    categories: [defaultCategories[2], defaultCategories[3]],
    posterImageURL: 'https://cdn.galaxycine.vn/media/2026/1/16/silent-hill-2-500_1768557335828.jpg',
    duration: '106 phút',
    description: 'Sau khi nhận được lá thư bí ẩn từ người bạn gái đã mất, James Sunderland cảm thấy bị thu hút bởi thị trấn Silent Hill và quyết định đặt chân đến đó, một thị trấn từng quen thuộc nay đã chìm trong bóng tối. Hàng loạt những thực thể quái quỷ như Kim Tự Tháp Đỏ, Y Tá Quỷ đang chờ đợi anh ta.',
    tickets: [defaultTickets[0], defaultTickets[1]],
  ),
  Film(
    id: 4,
    name: 'Bằng Chứng Sinh Tử',
    categories: [defaultCategories[4], defaultCategories[5], defaultCategories[6]],
    posterImageURL: 'https://cdn.galaxycine.vn/media/2026/1/20/bang-chung-sinh-tu-500_1768879551747.jpg',
    duration: '100 phút',
    description: '',
    tickets: [defaultTickets[0],],
  ),
  Film(
    id: 5,
    name: 'Phim Điện Ảnh Thám Tử Lừng Danh Conan: Quả Bom Chọc Trời',
    categories: [defaultCategories[1],],
    posterImageURL: 'https://cdn.galaxycine.vn/media/2026/1/15/conan-500_1768461797973.jpg',
    duration: '95 phút',
    description: 'Detective Conan: The Time Bombed Skyscraper/ Phim Điện Ảnh Thám Tử Lừng Danh Conan: Quả Bom Chọc Trời là bộ phim điện ảnh đầu tiên của chuỗi phim điện ảnh Thám Tử Lừng Danh Conan. Phim được chuyển thể dựa trên nguyên tác của Aoyama Gosho, do Kodama Kenji đạo diễn. Kudo Shinichi được kiến trúc sư nổi tiếng Moriya Teiji mời đến buổi tiệc trà tại dinh thự tư nhân. Tuy nhiên, do đã bị thu nhỏ, Shinichi vốn không thể tham gia buổi tiệc này. Thay vào đó, thám tử Mori, Ran và Conan đã cùng nhau đến dự thay cho Shinichi. Cùng lúc đó, Shinichi bất ngờ bị một kẻ ẩn danh thách thức qua điện thoại: cậu phải tìm ra những quả bom được đặt rải rác khắp Tokyo trước khi chúng phát nổ. Liệu cậu ấy có thể tìm thấy và vô hiệu hóa tất cả số bom trước khi quá muộn?',
    tickets: [defaultTickets[0]],
  ),
  Film(
    id: 6,
    name: '28 Năm Sau: Ngôi Đền Tử Thần',
    categories: [defaultCategories[2], defaultCategories[3]],
    posterImageURL: 'https://cdn.galaxycine.vn/media/2026/1/12/28-year-500_1768210133214.jpg',
    duration: '107 phút',
    description: 'Lấy bối cảnh 28 năm sau đại dịch virus khiến nước Anh sụp đổ, giữa thế giới bị phong tỏa nghiêm ngặt. Cậu bé Spike sau khi vào đất liền tìm cách chữa ung thư cho mẹ nhưng bất thành, đã không trở về với ngôi làng của mình nữa. Trong lúc phải tự sinh tồn, cậu bị buộc phải gia nhập giáo phái bạo lực của Jimmy, vốn đang trên đà xung đột với Tiến sĩ Kelson và Samson, kẻ mang virus Alpha.',
    tickets: [defaultTickets[0]],
  ),
  Film(
    id: 7,
    name: 'Tom And Jerry: Chiếc La Bàn Kỳ Bí',
    categories: [defaultCategories[1],],
    posterImageURL: 'https://cdn.galaxycine.vn/media/2025/12/26/tom-and-jerry-500_1766725769417.jpg',
    duration: '98 phút',
    description: 'Một chiếc la bàn bí ẩn bất ngờ mở ra cánh cổng kỳ diệu - nơi đầy ắp thử thách, tiếng cười và những màn rượt đuổi “kinh điển” cộp mác Tom & Jerry. Để trở về nhà, cặp đôi oan gia buộc phải hợp tác trước khi chiếc la bàn phá vỡ trật tự của mọi thế giới.',
    tickets: [defaultTickets[0]],
  ),
  Film(
    id: 8,
    name: 'Phi Vụ Động Trời 2',
    categories: [defaultCategories[1]],
    posterImageURL: 'https://cdn.galaxycine.vn/media/2025/11/3/zootopia-500_1762159348935.jpg',
    duration: '107 phút',
    description: 'Cô cảnh sát thỏ dũng cảm Judy Hopps và người bạn cáo Nick Wilde quay trở lại hợp tác để phá một vụ án mới, vụ án nguy hiểm và phức tạp nhất trong sự nghiệp của họ.',
    tickets: [defaultTickets[0]],
  ),
  Film(
    id: 9,
    name: 'Avatar: Lửa Và Tro Tàn',
    categories: [defaultCategories[0], defaultCategories[5], defaultCategories[7]],
    posterImageURL: 'https://cdn.galaxycine.vn/media/2025/12/15/avatar-3-500_1765782293833.jpg',
    duration: '197 phút',
    description: 'Sau một năm 2025 đầy biến động, điện ảnh Hollywood “chốt sổ” cuối năm bằng siêu phẩm Avatar: Fire and Ash (Tựa Việt: Avatar: Lửa Và Tro Tàn). Bom tấn được cả thế giới mong đợi khi viết tiếp câu chuyện còn dang dở của nhà Sully trong phần trước, đồng thời hé lộ mặt tối của người Na’vi - điều mà các phần trước chưa từng được kể. Đạo diễn James Cameron hứa hẹn sẽ mang đến phim mới phần hiệu ứng hình ảnh và công nghệ mô phỏng chuyển động phức tạp nhất cả thương hiệu. Avatar: Lửa Và Tro Tàn xứng đáng là bom tấn đáng mong đợi nhất và nhất định phải xem ở rạp trong dịp cuối năm nay để thưởng thức trọn vẹn phần hình ảnh đỉnh cao bậc nhất Hollywood. Khán giả có thể trải nghiệm mãn nhãn với đa định dạng 2D, 3D, IMAX, 4DX và ScreenX. Avatar: Lửa Và Tro Tàn lấy bối cảnh một năm sau khi gia đình Sully định cư tại bộ tộc Metkayina. Jake (Sam Worthington) và Neytiri (Zoe Saldaña) cùng các thành viên đang phải vật lộn với nỗi đau sau cái chết của Neteyam (Jamie Flatters). Tuy nhiên, thời gian đau buồn không kéo dài lâu khi Đại tá Quaritch (Stephen Lang) vẫn sống sót và chuẩn bị một cuộc tấn công quy mô lớn khác. Mối thù cá nhân giờ đây bùng nổ thành cuộc chiến định đoạt vận mệnh cả hành tinh, khi Quaritch liên minh với Tộc Tro (Mangkwan) - bộ tộc Navi hung hãn đại diện cho mặt tối của Pandora dưới sự dẫn dắt của nữ thủ lĩnh Varang đầy thù hận.',
    tickets: [defaultTickets[1]],
  ),
  Film(
    id: 10,
    name: 'Hàm Cá Mập',
    categories: [defaultCategories[2], defaultCategories[6]],
    posterImageURL: 'https://cdn.galaxycine.vn/media/2026/1/12/jaw-500_1768208979911.jpg',
    duration: '124 phút',
    description: 'Sau sự cố một người phụ nữ trẻ bị cá mập sát hại khi đang bơi gần bãi tắm của thị trấn du lịch Amity thuộc New England, cảnh sát trưởng Martin Brody đã muốn đóng cửa các bãi biển. Thế nhưng, thị trưởng Larry Vaughn lại ngăn cản vì lo sợ thị trấn sẽ kiệt quệ do mất nguồn doanh thu từ du khách. Nhà ngư học Matt Hooper cùng thuyền trưởng lão luyện Quint đã đề nghị hỗ trợ Brody truy bắt con quái vật khát máu. Bộ ba dấn thân vào cuộc chiến kịch tính giữa con người và thiên nhiên.',
    tickets: [defaultTickets[0], defaultTickets[2]],
  ),
];