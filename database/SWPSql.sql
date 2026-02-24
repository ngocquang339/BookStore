USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'BookShop')
BEGIN
    CREATE DATABASE BookShop;
END
GO

ALTER DATABASE [BookShop] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BookShop].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BookShop] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BookShop] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BookShop] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BookShop] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BookShop] SET ARITHABORT OFF 
GO
ALTER DATABASE [BookShop] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BookShop] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BookShop] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BookShop] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BookShop] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BookShop] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BookShop] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BookShop] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BookShop] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BookShop] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BookShop] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BookShop] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BookShop] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BookShop] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BookShop] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BookShop] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BookShop] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BookShop] SET RECOVERY FULL 
GO
ALTER DATABASE [BookShop] SET  MULTI_USER 
GO
ALTER DATABASE [BookShop] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BookShop] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BookShop] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BookShop] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BookShop] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BookShop] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BookShop', N'ON'
GO
ALTER DATABASE [BookShop] SET QUERY_STORE = ON
GO
ALTER DATABASE [BookShop] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BookShop]
GO
/****** Object:  Table [dbo].[Books]    Script Date: 1/27/2026 12:32:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Books](
	[book_id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[author] [nvarchar](100) NULL,
	[price] [decimal](18, 2) NOT NULL,
	[description] [nvarchar](max) NULL,
	[image] [varchar](max) NULL,
	[stock_quantity] [int] NULL,
	[sold_quantity] [int] NULL,
	[publisher] [nvarchar](100) NULL,
	[ISBN] [varchar](20) NULL,
	[category_id] [int] NULL,
	[is_active] [bit] NULL,
	[import_price] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[book_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 1/27/2026 12:32:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[create_at] [datetime] NULL,
	[user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CartItems]    Script Date: 1/27/2026 12:32:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CartItems](
	[cart_item_id] [int] IDENTITY(1,1) NOT NULL,
	[quantity] [int] NULL,
	[add_at] [datetime] NULL,
	[cart_id] [int] NULL,
	[book_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[cart_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 1/27/2026 12:32:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Review]    Script Date: 1/27/2026 12:32:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Review](
	[review_id] [int] IDENTITY(1,1) NOT NULL,
	[rating] [int] NULL,
	[comment] [nvarchar](max) NULL,
	[create_at] [datetime] NULL,
	[user_id] [int] NULL,
	[book_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[review_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 1/27/2026 12:32:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[fullname] [nvarchar](100) NULL,
	[username] [nvarchar](100) NOT NULL,
	[email] [varchar](100) NOT NULL,
	[phone_number] [varchar](15) NULL,
	[address] [nvarchar](255) NULL,
	[password] [varchar](255) NOT NULL,
	[role] [int] NULL,
	[status] [bit] NULL,
	[failed_login_attempts] [int] NULL,
	[createAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Books] ON 

-- 1. Create ORDERS Table (The "Header" of the receipt)
CREATE TABLE [dbo].[Orders](
    [order_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NULL,              -- Who bought it?
    [order_date] [datetime] DEFAULT GETDATE(), -- When?
    [total_amount] [decimal](18, 2) NOT NULL, -- Total cost
    [status] [int] DEFAULT 1,          -- 1: Pending, 2: Shipping, 3: Completed, 4: Cancelled
    [shipping_address] [nvarchar](255) NOT NULL, -- Where to send?
    [phone_number] [varchar](15) NOT NULL, -- Contact info
    [payment_method] [nvarchar](50) NULL, -- COD, Banking, etc.
    PRIMARY KEY CLUSTERED ([order_id] ASC),
    FOREIGN KEY ([user_id]) REFERENCES [dbo].[Users] ([user_id])
);
GO

-- 2. Create ORDER_DETAILS Table (The "Items" on the receipt)
CREATE TABLE [dbo].[OrderDetails](
    [detail_id] [int] IDENTITY(1,1) NOT NULL,
    [order_id] [int] NOT NULL,         -- Links to the Order above
    [book_id] [int] NOT NULL,          -- Links to the Book
    [quantity] [int] NOT NULL,         -- How many copies?
    [price] [decimal](18, 2) NOT NULL, -- Price AT THE TIME of purchase (Crucial!)
    PRIMARY KEY CLUSTERED ([detail_id] ASC),
    FOREIGN KEY ([order_id]) REFERENCES [dbo].[Orders] ([order_id]) ON DELETE CASCADE,
    FOREIGN KEY ([book_id]) REFERENCES [dbo].[Books] ([book_id])
);
GO

INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (2, N'Đắc Nhân Tâm', N'Dale Carnegie', CAST(120000.00 AS Decimal(18, 2)), N'Nghệ thuật giao tiếp và ứng xử', N'dac_nhan_tam.jpg', 200, 150, N'NXB Trẻ', N'978100000001', 1, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (3, N'Quẳng Gánh Lo Đi Và Vui Sống', N'Dale Carnegie', CAST(110000.00 AS Decimal(18, 2)), N'Giải tỏa lo âu, sống tích cực', N'quang_ganh_lo.jpg', 180, 120, N'NXB Trẻ', N'978100000002', 1, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (4, N'7 Thói Quen Hiệu Quả', N'Stephen R. Covey', CAST(150000.00 AS Decimal(18, 2)), N'Thói quen thành công bền vững', N'7_habits.jpg', 160, 100, N'NXB Tổng Hợp', N'978100000003', 4, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (5, N'Nhà Giả Kim', N'Paulo Coelho', CAST(130000.00 AS Decimal(18, 2)), N'Hành trình tìm kiếm ý nghĩa cuộc sống', N'nha_gia_kim.jpg', 170, 140, N'NXB Văn Học', N'978100000004', 2, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (6, N'Tuổi Trẻ Đáng Giá Bao Nhiêu', N'Rosie Nguyễn', CAST(95000.00 AS Decimal(18, 2)), N'Lời khuyên cho người trẻ', N'tuoi_tre.jpg', 220, 180, N'NXB Hội Nhà Văn', N'978100000005', 3, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (7, N'Hạt Giống Tâm Hồn', N'Nhiều tác giả', CAST(90000.00 AS Decimal(18, 2)), N'Những câu chuyện truyền cảm hứng', N'hat_giong.jpg', 250, 200, N'NXB Trẻ', N'978100000006', 3, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (8, N'Sống Đơn Giản Cho Mình Thanh Thản', N'Shunyamurti', CAST(105000.00 AS Decimal(18, 2)), N'Sống chậm và an yên', N'song_don_gian.jpg', 150, 90, N'NXB Lao Động', N'978100000007', 5, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (9, N'The Power of Now', N'Eckhart Tolle', CAST(160000.00 AS Decimal(18, 2)), N'Sức mạnh của hiện tại', N'power_of_now.jpg', 130, 85, N'NXB Thế Giới', N'978100000008', 2, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (10, N'Dám Bị Ghét', N'Ichiro Kishimi', CAST(140000.00 AS Decimal(18, 2)), N'Triết lý sống tự do', N'dam_bi_ghet.jpg', 190, 130, N'NXB Trẻ', N'978100000009', 2, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (11, N'Không Bao Giờ Là Thất Bại', N'Chung Ju Yung', CAST(115000.00 AS Decimal(18, 2)), N'Bài học vượt khó', N'khong_that_bai.jpg', 140, 95, N'NXB Lao Động', N'978100000010', 4, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (12, N'Nghĩ Giàu Và Làm Giàu', N'Napoleon Hill', CAST(155000.00 AS Decimal(18, 2)), N'Tư duy thành công', N'think_rich.jpg', 170, 120, N'NXB Tổng Hợp', N'978100000011', 4, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (13, N'Đời Ngắn Đừng Ngủ Dài', N'Robin Sharma', CAST(135000.00 AS Decimal(18, 2)), N'Sống có mục tiêu', N'doi_ngan.jpg', 160, 110, N'NXB Trẻ', N'978100000012', 3, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (14, N'Bí Mật Của May Mắn', N'Alex Rovira', CAST(100000.00 AS Decimal(18, 2)), N'Tạo ra vận may cho chính mình', N'bi_mat_may_man.jpg', 180, 125, N'NXB Trẻ', N'978100000013', 3, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (15, N'Sống Như Ngày Mai Sẽ Chết', N'James Altucher', CAST(125000.00 AS Decimal(18, 2)), N'Động lực sống mạnh mẽ', N'song_nhu_ngay_mai.jpg', 140, 90, N'NXB Thế Giới', N'978100000014', 3, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (16, N'Khi Mọi Điều Không Như Ý', N'Mark Manson', CAST(145000.00 AS Decimal(18, 2)), N'Nghệ thuật sống thực tế', N'mark_manson.jpg', 200, 160, N'NXB Lao Động', N'978100000015', 5, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (17, N'Tôi Tài Giỏi, Bạn Cũng Thế', N'Adam Khoo', CAST(110000.00 AS Decimal(18, 2)), N'Tự tin và phát triển bản thân', N'toi_tai_gioi.jpg', 210, 170, N'NXB Trẻ', N'978100000016', 3, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (18, N'Đừng Bao Giờ Đi Ăn Một Mình', N'Keith Ferrazzi', CAST(165000.00 AS Decimal(18, 2)), N'Xây dựng mối quan hệ', N'never_eat_alone.jpg', 120, 80, N'NXB Tổng Hợp', N'978100000017', 1, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (19, N'Sức Mạnh Của Thói Quen', N'Charles Duhigg', CAST(150000.00 AS Decimal(18, 2)), N'Thay đổi thói quen để thành công', N'power_habit.jpg', 180, 130, N'NXB Lao Động', N'978100000018', 4, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (20, N'Chọn Lọc Cảm Xúc', N'Daniel Goleman', CAST(135000.00 AS Decimal(18, 2)), N'Trí tuệ cảm xúc', N'emotional.jpg', 160, 100, N'NXB Trẻ', N'978100000019', 5, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (21, N'Tư Duy Nhanh Và Chậm', N'Daniel Kahneman', CAST(170000.00 AS Decimal(18, 2)), N'Hiểu cách con người suy nghĩ', N'thinking_fast_slow.jpg', 140, 85, N'NXB Thế Giới', N'978100000020', 2, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (22, N'Mỗi Lần Vấp Ngã Là Một Lần Trưởng Thành', N'Liêu Trí Phong', CAST(100000.00 AS Decimal(18, 2)), N'Vượt qua thất bại', N'vap_nga.jpg', 160, 110, N'NXB Trẻ', N'978100000021', 3, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (23, N'Buông Bỏ Phiền Não', N'Thích Nhất Hạnh', CAST(115000.00 AS Decimal(18, 2)), N'An nhiên giữa cuộc đời', N'buong_bo.jpg', 190, 150, N'NXB Tôn Giáo', N'978100000022', 5, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (24, N'An Nhiên Giữa Những Thăng Trầm', N'OSHO', CAST(130000.00 AS Decimal(18, 2)), N'Sống tỉnh thức', N'an_nhien.jpg', 150, 95, N'NXB Lao Động', N'978100000023', 2, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (25, N'Đời Đơn Giản Khi Ta Đơn Giản', N'Thái Kim Lan', CAST(105000.00 AS Decimal(18, 2)), N'Lối sống tối giản', N'doi_don_gian.jpg', 170, 120, N'NXB Trẻ', N'978100000024', 5, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (26, N'Đi Tìm Lẽ Sống', N'Viktor Frankl', CAST(145000.00 AS Decimal(18, 2)), N'Ý nghĩa cuộc đời', N'di_tim_le_song.jpg', 130, 80, N'NXB Thế Giới', N'978100000025', 2, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (27, N'Sống Chậm Lại', N'Hae Min', CAST(120000.00 AS Decimal(18, 2)), N'Bình yên trong tâm hồn', N'song_cham.jpg', 180, 140, N'NXB Trẻ', N'978100000026', 5, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (28, N'Khi Bạn Đang Mơ Thì Người Khác Đang Nỗ Lực', N'Lý Thượng Long', CAST(110000.00 AS Decimal(18, 2)), N'Tạo động lực hành động', N'dang_mo.jpg', 160, 120, N'NXB Lao Động', N'978100000027', 3, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (29, N'Tư Duy Tích Cực', N'Norman Vincent Peale', CAST(135000.00 AS Decimal(18, 2)), N'Sức mạnh của niềm tin', N'positive.jpg', 170, 130, N'NXB Trẻ', N'978100000028', 3, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (30, N'Bình Tĩnh Khi Ế', N'Rando Kim', CAST(95000.00 AS Decimal(18, 2)), N'Thấu hiểu cảm xúc bản thân', N'binh_tinh.jpg', 200, 160, N'NXB Trẻ', N'978100000029', 5, 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Books] ([book_id], [title], [author], [price], [description], [image], [stock_quantity], [sold_quantity], [publisher], [ISBN], [category_id], [is_active], [import_price]) VALUES (31, N'Đừng Lựa Chọn An Nhàn Khi Còn Trẻ', N'Cảnh Thiên', CAST(125000.00 AS Decimal(18, 2)), N'Nỗ lực tuổi trẻ', N'an_nhan.jpg', 190, 150, N'NXB Trẻ', N'978100000030', 3, 1, CAST(0.00 AS Decimal(18, 2)))

SET IDENTITY_INSERT [dbo].[Books] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (1, N'Self-help', N'Sách phát triển bản thân, thay đổi tư duy và cải thiện cuộc sống')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (2, N'Động lực – Truyền cảm hứng', N'Sách tạo động lực sống, khơi dậy ý chí và niềm tin')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (3, N'Kỹ năng giao tiếp', N'Sách về giao tiếp, thuyết phục và xây dựng mối quan hệ')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (4, N'Tư duy – Thái độ sống', N'Sách về tư duy tích cực, mindset và cách nhìn cuộc đời')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (5, N'Quản lý thời gian', N'Sách hướng dẫn sắp xếp thời gian và nâng cao hiệu suất')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (6, N'Thành công – Sự nghiệp', N'Sách chia sẻ con đường thành công và phát triển sự nghiệp')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (7, N'Tâm lý học ứng dụng', N'Sách tâm lý học gần gũi, áp dụng vào đời sống')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (8, N'Kỹ năng lãnh đạo', N'Sách về lãnh đạo bản thân và dẫn dắt người khác')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (9, N'Hạnh phúc – Cân bằng cuộc sống', N'Sách về hạnh phúc, cân bằng cảm xúc và cuộc sống')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (10, N'Triết lý sống', N'Sách chia sẻ những triết lý sống sâu sắc và thực tế')
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (1, NULL, N'QuangLee1512', N'grtkahn@umaw.site', NULL, NULL, N'1234', 2, 1, 0, CAST(N'2026-01-22T16:31:18.300' AS DateTime))
INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (2, NULL, N'brfb', N'cscwdfcvwdc@gmail.com', NULL, NULL, N'1234', 2, 1, 0, CAST(N'2026-01-22T17:00:28.750' AS DateTime))
INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (3, NULL, N'bfbf', N'0357355646', NULL, NULL, N'1234', 2, 1, 0, CAST(N'2026-01-22T19:40:13.470' AS DateTime))
INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (5, NULL, N'sa', N'lequang123@gmail.com', NULL, NULL, N'123', 2, 1, 0, CAST(N'2026-01-26T03:05:57.383' AS DateTime))
INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (6, NULL, N'morning', N'kietle123@gmail.com', NULL, NULL, N'123', 2, 1, 0, CAST(N'2026-01-26T09:34:31.147' AS DateTime))
INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (7, NULL, N'afternoon', N'hello123@gmail.com', NULL, NULL, N'123', 2, 1, 0, CAST(N'2026-01-26T09:42:28.310' AS DateTime))
INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (8, N'Nhân viên Kho', N'warehouse', N'warehouse@bookstore.com', NULL, NULL, N'123', 4, 1, 0, CAST(N'2026-01-26T13:43:33.410' AS DateTime))
INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (9, NULL, N'hello', N'Lee@gmail.com', NULL, NULL, N'123', 2, 1, 0, CAST(N'2026-01-26T13:55:48.693' AS DateTime))
INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (10, NULL, N'hi', N'cscscscs@gdvdfvfd', NULL, NULL, N'123', 2, 1, 0, CAST(N'2026-01-26T13:59:18.000' AS DateTime))
INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (11, N'Trần Quản Trị', N'admin', N'admin@bookstore.com', N'0901000001', N'Ba Đình, Hà Nội', N'123', 1, 1, 0, CAST(N'2026-01-26T22:14:39.290' AS DateTime))
INSERT [dbo].[Users] ([user_id], [fullname], [username], [email], [phone_number], [address], [password], [role], [status], [failed_login_attempts], [createAt]) VALUES (12, N'Nhân viên Bán Hàng', N'sale', N'sale01@bookstore.com', N'0988666888', N'Hà Nội', N'123', 3, 1, 0, CAST(N'2026-02-14T09:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__AB6E6164D6152BBD]    Script Date: 1/27/2026 12:32:41 AM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Books] ADD  DEFAULT ((0)) FOR [stock_quantity]
GO
ALTER TABLE [dbo].[Books] ADD  DEFAULT ((0)) FOR [sold_quantity]
GO
ALTER TABLE [dbo].[Books] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[Books] ADD  DEFAULT ((0)) FOR [import_price]
GO
ALTER TABLE [dbo].[Cart] ADD  DEFAULT (getdate()) FOR [create_at]
GO
ALTER TABLE [dbo].[CartItems] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[CartItems] ADD  DEFAULT (getdate()) FOR [add_at]
GO
ALTER TABLE [dbo].[Review] ADD  DEFAULT (getdate()) FOR [create_at]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((2)) FOR [role]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [failed_login_attempts]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [createAt]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [FK_Books_Categories] FOREIGN KEY([category_id])
REFERENCES [dbo].[Categories] ([category_id])
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [FK_Books_Categories]
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD  CONSTRAINT [FK_Cart_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [FK_Cart_Users]
GO
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD  CONSTRAINT [FK_CartItems_Books] FOREIGN KEY([book_id])
REFERENCES [dbo].[Books] ([book_id])
GO
ALTER TABLE [dbo].[CartItems] CHECK CONSTRAINT [FK_CartItems_Books]
GO
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD  CONSTRAINT [FK_CartItems_Cart] FOREIGN KEY([cart_id])
REFERENCES [dbo].[Cart] ([cart_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CartItems] CHECK CONSTRAINT [FK_CartItems_Cart]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD  CONSTRAINT [FK_Review_Books] FOREIGN KEY([book_id])
REFERENCES [dbo].[Books] ([book_id])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [FK_Review_Books]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD  CONSTRAINT [FK_Review_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [FK_Review_Users]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD CHECK  (([rating]>=(1) AND [rating]<=(5)))
GO
USE [master]
GO
ALTER DATABASE [BookShop] SET  READ_WRITE 
GO

