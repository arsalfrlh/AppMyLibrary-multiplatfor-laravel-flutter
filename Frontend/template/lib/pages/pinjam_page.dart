import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:template/models/buku.dart';
import 'package:template/models/peminjaman.dart';
import 'package:template/models/user.dart';
import 'package:template/pages/peminjaman_page.dart';
import 'package:template/services/api_service.dart';

class PinjamPage extends StatefulWidget {
  final Buku buku;
  PinjamPage({required this.buku});

  @override
  _PinjamPageState createState() => _PinjamPageState();
}

class _PinjamPageState extends State<PinjamPage> {
  final product = demoProducts[0];
  ApiService apiService = ApiService();
  User? _user;
  final jumlahController = TextEditingController();
  final tanggalPinjam = TextEditingController();
  DateTime? selectTanggal;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    User? user = await apiService.getUser();
    setState(() {
      _user = user;
    });
  }

  Future<void> pilihTanggal(BuildContext context) async{
    final DateTime? pilih = await showDatePicker(
      context: context, 
      initialDate: selectTanggal ?? DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2101)
      );
      if(pilih != null && pilih != selectTanggal){
        setState(() {
          selectTanggal = pilih;
        });
      }
  }

  void _pinjam() async {
    if(jumlahController.text.isNotEmpty && selectTanggal != null){
      final pinjamBuku = Peminjaman(
        id: 0,
        id_buku: widget.buku.id,
        jumlah: int.parse(jumlahController.text),
        tanggalPinjam: selectTanggal != null
        ? "${selectTanggal!.year}-${selectTanggal!.month}-${selectTanggal!.day}"
        : "",
      );

      final response = await apiService.pinjam(pinjamBuku, _user!.id); //menympan data api di variabel response
      if(response['success'] == true){ //return dari function pinjam| jika arraykey successnya true akan mengisi data peminjaman di database dan mengarahkan ke peminjamn user dan menampilkan pesan
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PeminjamanPage(id_user: _user!.id)));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.green));
      }else if(response['success'] == false){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server sedang error'), backgroundColor: Colors.red));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Semua field tidak boleh kosong'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text(
                      "4.7",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.string(starIcon),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _user == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ProductImages(
                  product: product,
                  buku: widget.buku,
                ),
                TopRoundedContainer(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ProductDescription(
                        product: product,
                        pressOnSeeMore: () {},
                        buku: widget.buku,
                      ),
                      TopRoundedContainer(
                        color: const Color(0xFFF6F7F9),
                        child: Column(
                          children: [
                            ColorDots(
                              tanggalPinjam: tanggalPinjam,
                              product: product,
                              jumlah: jumlahController,
                              selectTanggal: selectTanggal,
                              pilihTanggal: () => pilihTanggal(context), //tambahkan (context) jika ingin mengklik dan memunculkan alert dialog tanggal
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFFF7643),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onPressed: widget.buku.stok > 0 ? _pinjam : null,
              child: widget.buku.stok > 0
                  ? Text("Pinjam")
                  : Text('Stok tidak tersedia'),
            ),
          ),
        ),
      ),
    );
  }
}

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }
}

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
    required this.buku,
  }) : super(key: key);

  final Product product;
  final Buku buku;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 238,
          child: AspectRatio(
            aspectRatio: 1,
            child: widget.buku.gambar != null
            ? Image.network(
                'http://10.0.2.2:8000/images/${widget.buku.gambar}', 
                errorBuilder:(context, error, stackTrace) => Container(
                  child: CircularProgressIndicator())
                  )
                : Container(color: Colors.grey, child: Icon(Icons.image_not_supported),),
          ),
        ),
        // SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              widget.product.images.length,
              (index) => SmallProductImage(
                isSelected: index == selectedImage,
                press: () {
                  setState(() {
                    selectedImage = index;
                  });
                },
                image: widget.product.images[index],
                buku: widget.buku,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class SmallProductImage extends StatefulWidget {
  const SmallProductImage(
      {super.key,
      required this.isSelected,
      required this.press,
      required this.image,
      required this.buku});

  final bool isSelected;
  final VoidCallback press;
  final String image;
  final Buku buku;

  @override
  State<SmallProductImage> createState() => _SmallProductImageState();
}

class _SmallProductImageState extends State<SmallProductImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color(0xFFFF7643)
                  .withOpacity(widget.isSelected ? 1 : 0)),
        ),
        child: widget.buku.gambar != null
            ? Image.network(
              'http://10.0.2.2:8000/images/${widget.buku.gambar}', 
              errorBuilder: (context, error, stackTrace) => Container(
                child: CircularProgressIndicator()),)
            : Container(
                child: Icon(Icons.image_not_supported),
                color: Colors.grey,
              ),
      ),
    );
  }
}

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
    required this.buku,
  }) : super(key: key);

  final Product product;
  final Buku buku;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            buku.judul,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 48,
            decoration: BoxDecoration(
              color: product.isFavourite
                  ? const Color(0xFFFFE6E6)
                  : const Color(0xFFF5F6F9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: SvgPicture.string(
              heartIcon,
              colorFilter: ColorFilter.mode(
                  product.isFavourite
                      ? const Color(0xFFFF4848)
                      : const Color(0xFFDBDEE4),
                  BlendMode.srcIn),
              height: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            'Ini adalah buku ${buku.judul} yang ditulis oleh ${buku.penulis}, anda dapat membacanya setelah melakukan peminjaman',
            maxLines: 3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  'Stok: ${buku.stok}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFFFF7643)),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.book,
                  size: 12,
                  color: Color(0xFFFF7643),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ColorDots extends StatelessWidget {
  const ColorDots(
      {Key? key,
      required this.product,
      required this.jumlah,
      required this.tanggalPinjam,
      this.selectTanggal,
      required this.pilihTanggal})
      : super(key: key);

  final Product product;
  final TextEditingController jumlah;
  final TextEditingController tanggalPinjam;
  final DateTime? selectTanggal;
  final VoidCallback pilihTanggal;

  @override
  Widget build(BuildContext context) {
    // Now this is fixed and only for demo
    int selectedColor = 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ...List.generate(
            product.colors.length,
            (index) => ColorDot(
              jumlah: jumlah,
              color: product.colors[index],
              isSelected: index == selectedColor,
            ),
          ),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                  margin: const EdgeInsets.only(right: 2),
                  padding: const EdgeInsets.all(8),
                  height: 100,
                  width: 170,
                  child: TextField(
                    controller: TextEditingController(
                      text:  selectTanggal != null 
                      ? "${selectTanggal!.year}-${selectTanggal!.month}-${selectTanggal!.day}"
                      : "Pilih Tanggal",
                    ),
                    onTap: pilihTanggal,
                    decoration: InputDecoration(
                        labelText: 'Tanggal Pinjam',
                        icon: Icon(Icons.date_range)),
                  ))),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  const ColorDot(
      {Key? key,
      required this.color,
      this.isSelected = false,
      required this.jumlah})
      : super(key: key);

  final Color color;
  final bool isSelected;
  final TextEditingController jumlah;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 2),
        padding: const EdgeInsets.all(8),
        height: 100,
        width: 150,
        child: TextField(
          controller: jumlah,
          decoration:
              InputDecoration(labelText: 'Jumlah', icon: Icon(Icons.book)),
        ));
  }
}

class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn({
    Key? key,
    required this.icon,
    required this.press,
    this.showShadow = false,
  }) : super(key: key);

  final IconData icon;
  final GestureTapCancelCallback press;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          if (showShadow)
            BoxShadow(
              offset: const Offset(0, 6),
              blurRadius: 10,
              color: const Color(0xFFB0B0B0).withOpacity(0.2),
            ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFF7643),
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: [
      "https://i.postimg.cc/c19zpJ6f/Image-Popular-Product-1.png",
      "https://i.postimg.cc/zBLc7fcF/ps4-console-white-2.png",
      "https://i.postimg.cc/KYpWtTJY/ps4-console-white-3.png",
      "https://i.postimg.cc/YSCV4RNV/ps4-console-white-4.png"
    ],
    colors: [
      Colors.white,
    ],
    title: "Wireless Controller for PS4™",
    price: 64.99,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "https://i.postimg.cc/CxD6nH74/Image-Popular-Product-2.png",
    ],
    colors: [
      Colors.white,
    ],
    title: "Nike Sport White - Man Pant",
    price: 50.5,
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "https://i.postimg.cc/1XjYwvbv/glap.png",
    ],
    colors: [
      Colors.white,
    ],
    title: "Gloves XC Omega - Polygon",
    price: 36.55,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "https://i.postimg.cc/d1QWXMYW/Image-Popular-Product-3.png",
    ],
    colors: [
      Colors.white,
    ],
    title: "Gloves XC Omega - Polygon",
    price: 36.55,
    description: description,
    rating: 4.1,
    isFavourite: false,
    isPopular: true,
  ),
];

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";

const starIcon =
    '''<svg width="13" height="12" viewBox="0 0 13 12" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M12.7201 5.50474C12.9813 5.23322 13.0659 4.86077 12.9476 4.50957C12.8292 4.15777 12.5325 3.90514 12.156 3.83313L9.12773 3.25704C9.03883 3.23992 8.96219 3.18621 8.91743 3.11007L7.41279 0.515295C7.22517 0.192424 6.88365 0 6.49983 0C6.116 0 5.7751 0.192424 5.58748 0.515295L4.08284 3.11007C4.03808 3.18621 3.96144 3.23992 3.87192 3.25704L0.844252 3.83313C0.467173 3.90514 0.171028 4.15777 0.0526921 4.50957C-0.0662565 4.86077 0.0189695 5.23322 0.280166 5.50474L2.37832 7.68397C2.43963 7.74831 2.46907 7.83508 2.45803 7.92185L2.09199 10.8725C2.04661 11.2397 2.20419 11.5891 2.51566 11.8063C2.6996 11.935 2.91236 11.9999 3.12696 11.9999C3.27595 11.9999 3.42617 11.9687 3.56842 11.9055L6.36984 10.6577C6.45262 10.6211 6.54704 10.6211 6.62981 10.6577L9.43185 11.9055C9.7795 12.0601 10.1725 12.0235 10.484 11.8063C10.7955 11.5891 10.9537 11.2397 10.9083 10.8725L10.5416 7.92244C10.5306 7.83508 10.56 7.74831 10.6226 7.68397L12.7201 5.50474Z" fill="#FFC416"/>
</svg>
''';

const heartIcon =
    '''<svg width="18" height="16" viewBox="0 0 18 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M16.5266 8.61383L9.27142 15.8877C9.12207 16.0374 8.87889 16.0374 8.72858 15.8877L1.47343 8.61383C0.523696 7.66069 0 6.39366 0 5.04505C0 3.69644 0.523696 2.42942 1.47343 1.47627C2.45572 0.492411 3.74438 0 5.03399 0C6.3236 0 7.61225 0.492411 8.59454 1.47627C8.81857 1.70088 9.18143 1.70088 9.40641 1.47627C11.3691 -0.491451 14.5629 -0.491451 16.5266 1.47627C17.4763 2.42846 18 3.69548 18 5.04505C18 6.39366 17.4763 7.66165 16.5266 8.61383Z" fill="#DBDEE4"/>
</svg>
''';
