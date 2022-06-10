import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String manLookRightImageUrl =
    'https://www.buro247.sg/thumb/950x700/local/images/buro/galleries/2020/01/the-best-street-style-from-milan-mens-fashion-week-fall-winter-2020-day4-burosg-38.jpg';
const String myImageUrl =
    'https://asset.kompas.com/crops/vQGlHJB1sbvpgNbLh4__whZiR5E=/0x0:1200x800/750x500/data/photo/2020/06/27/5ef73dd952cf5.jpg';
const String womanLookLeftImageUrl =
    'https://cdn.cliqueinc.com/posts/282135/italian-style-282135-1567351734244-main.700x0c.jpg';

Cart cart = Cart();

class ECommerce extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Builder(
        builder: (context) => HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchString;
  @override
  void initState() {
    searchString = '';
    super.initState();
  }

  void setSearchString(String value) => setState(() {
        searchString = value;
      });

  @override
  Widget build(BuildContext context) {
    var listViewPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 24);
    List<Widget> searchResultTiles = [];
    if (searchString.isNotEmpty) {
      searchResultTiles = products
          .where(
              (p) => p.name.toLowerCase().contains(searchString.toLowerCase()))
          .map(
            (p) => ProductTile(product: p),
          )
          .toList();
    }
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          onChanged: setSearchString,
        ),
        actions: [
          CartAppBarAction(),
        ],
      ),
      body: searchString.isNotEmpty
          ? GridView.count(
              padding: listViewPadding,
              crossAxisCount: 2,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: .78,
              children: searchResultTiles,
            )
          : ListView(
              padding: listViewPadding,
              children: [
                Text(
                  "Kategori Belanja",
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 16),
                CategoryTile(
                  imageUrl: manLookRightImageUrl,
                  category: mensCategory,
                  imageAlignment: Alignment.topCenter,
                ),
                SizedBox(height: 16),
                CategoryTile(
                  imageUrl: womanLookLeftImageUrl,
                  category: womensCategory,
                  imageAlignment: Alignment.topCenter,
                ),
                SizedBox(height: 16),
                CategoryTile(
                  imageUrl: myImageUrl,
                  category: petsCategory,
                ),
              ],
            ),
    );
  }
}

class CartAppBarAction extends StatefulWidget {
  @override
  _CartAppBarActionState createState() => _CartAppBarActionState();
}

class _CartAppBarActionState extends State<CartAppBarAction> {
  @override
  void initState() {
    cart.addListener(blankSetState);
    super.initState();
  }

  @override
  void dispose() {
    cart.removeListener(blankSetState);
    super.dispose();
  }

  void blankSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.shopping_cart,
          ),
          if (cart.itemsInCart.length > 0)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        cart.itemsInCart.length.toString(),
                        style: TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      onPressed: () => _pushScreen(
        context: context,
        screen: CartScreen(),
      ),
    );
  }
}

class ProductScreen extends StatefulWidget {
  ProductScreen({@required this.product});
  final Product product;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Product get product => widget.product;
  String selectedImageUrl;
  String selectedSize;

  @override
  void initState() {
    selectedImageUrl = product.imageUrls.first;
    selectedSize = product.sizes?.first;
    super.initState();
  }

  void setSelectedImageUrl(String url) {
    setState(() {
      selectedImageUrl = url;
    });
  }

  void setSelectedSize(String size) {
    setState(() {
      selectedSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imagePreviews = product.imageUrls
        .map(
          (url) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => setSelectedImageUrl(url),
              child: Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: selectedImageUrl == url
                      ? Border.all(
                          color: Theme.of(context).accentColor, width: 1.75)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  url,
                ),
              ),
            ),
          ),
        )
        .toList();

    List<Widget> sizeSelectionWidgets = product.sizes
            ?.map(
              (s) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setSelectedSize(s);
                  },
                  child: Container(
                    height: 42,
                    width: 38,
                    decoration: BoxDecoration(
                      color: selectedSize == s
                          ? Theme.of(context).accentColor
                          : null,
                      border: Border.all(
                        color: Colors.grey[350],
                        width: 1.25,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        s,
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: selectedSize == s ? Colors.white : null),
                      ),
                    ),
                  ),
                ),
              ),
            )
            ?.toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        actions: [
          CartAppBarAction(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .35,
            color: kGreyBackground,
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.network(
                    selectedImageUrl,
                    fit: BoxFit.cover,
                    color: kGreyBackground,
                    colorBlendMode: BlendMode.multiply,
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imagePreviews,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "\Rp." + product.cost.toString(),
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: Theme.of(context).accentColor,
                        ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    product.description ?? "Deskripsi Produk.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(height: 1.5),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  if (sizeSelectionWidgets?.isNotEmpty) ...[
                    Text(
                      "Ukuran",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: sizeSelectionWidgets,
                    ),
                  ],
                  Spacer(),
                  Center(
                    child: CallToActionButton(
                      onPressed: () => cart.add(
                        OrderItem(
                          product: product,
                          selectedSize: selectedSize,
                        ),
                      ),
                      labelText: "Tambahkan ke Keranjang Belanja",
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CallToActionButton extends StatelessWidget {
  const CallToActionButton({
    this.onPressed,
    this.labelText,
    this.minSize = const Size(266, 45),
  });
  final Function onPressed;
  final String labelText;
  final Size minSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: minSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        labelText,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  CategoryScreen({this.category});
  final Category category;

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

enum Filters { popular, recent, sale }

class _CategoryScreenState extends State<CategoryScreen> {
  Category get category => widget.category;
  Filters filterValue = Filters.popular;
  String selection;
  List<Product> _products;

  @override
  void initState() {
    selection = category.selections?.first;
    _products = products.where((p) => p.category == category).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ProductRow> productRows = category.selections
        .map((s) => ProductRow(
              productType: s,
              products: _products
                  .where((p) => p.productType.toLowerCase() == s.toLowerCase())
                  .toList(),
            ))
        .toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(category.title),
        actions: [
          CartAppBarAction(),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 18),
        itemCount: productRows.length,
        itemBuilder: (_, index) => productRows[index],
        separatorBuilder: (_, index) => SizedBox(
          height: 18,
        ),
      ),
    );
  }
}

class ProductRow extends StatelessWidget {
  const ProductRow({this.products, this.productType});
  final String productType;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    List<ProductTile> _productTiles =
        products.map((p) => ProductTile(product: p)).toList();

    return _productTiles.isEmpty
        ? SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 18.0,
                ),
                child: Text(
                  productType,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 205,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  itemCount: _productTiles.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) => _productTiles[index],
                  separatorBuilder: (_, index) => SizedBox(
                    width: 24,
                  ),
                ),
              ),
            ],
          );
  }
}

class ProductTile extends StatelessWidget {
  const ProductTile({
    @required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        _pushScreen(
          context: context,
          screen: ProductScreen(product: product),
        );
      },
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(product: product),
            SizedBox(
              height: 8,
            ),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Spacer(),
            Text(
              "\Rp.${product.cost.toString()}",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Theme.of(context).accentColor),
            )
          ],
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .95,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: kGreyBackground,
        ),
        clipBehavior: Clip.hardEdge,
        child: Image.network(
          product.imageUrls.first,
          loadingBuilder: (_, child, loadingProgress) => loadingProgress == null
              ? child
              : Center(child: CircularProgressIndicator()),
          color: kGreyBackground,
          colorBlendMode: BlendMode.multiply,
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    cart.addListener(updateState);
  }

  @override
  void dispose() {
    cart.removeListener(updateState);
    super.dispose();
  }

  void updateState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    List<Widget> orderItemRows = cart.itemsInCart
        .map(
          (item) => Row(
            children: [
              SizedBox(
                width: 125,
                child: ProductImage(
                  product: item.product,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "\Rp." + item.product.cost.toString(),
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: Theme.of(context).accentColor,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => cart.remove(item),
                color: Colors.red,
              )
            ],
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text("Keranjang Belanja"),
            Text(
              cart.itemsInCart.length.toString() + " items",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          if (orderItemRows != null && orderItemRows.isNotEmpty)
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                itemCount: orderItemRows.length,
                itemBuilder: (_, index) => orderItemRows[index],
                separatorBuilder: (_, index) => SizedBox(
                  height: 16,
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text("Keranjang Belanja Kosong!"),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      "\Rp." + cart.totalCost.toString(),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
                CallToActionButton(
                  onPressed: () {},
                  labelText: "Proses Checkout",
                  minSize: Size(220, 45),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    this.category,
    this.imageUrl,
    this.imageAlignment = Alignment.center,
  });
  final String imageUrl;
  final Category category;
  final Alignment imageAlignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pushScreen(
        context: context,
        screen: CategoryScreen(
          category: category,
        ),
      ),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              color: kGreyBackground,
              colorBlendMode: BlendMode.darken,
              alignment: imageAlignment,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                category.title.toUpperCase(),
                style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({this.onChanged});

  final Function(String) onChanged;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        onChanged: widget.onChanged,
        controller: _textEditingController,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: kIsWeb ? EdgeInsets.only(top: 10) : EdgeInsets.zero,
          prefixIconConstraints: BoxConstraints(
            minHeight: 36,
            minWidth: 36,
          ),
          prefixIcon: Icon(
            Icons.search,
          ),
          hintText: "Cari Produk",
          suffixIconConstraints: BoxConstraints(
            minHeight: 36,
            minWidth: 36,
          ),
          suffixIcon: IconButton(
            constraints: BoxConstraints(
              minHeight: 36,
              minWidth: 36,
            ),
            splashRadius: 24,
            icon: Icon(
              Icons.clear,
            ),
            onPressed: () {
              _textEditingController.clear();
              widget.onChanged(_textEditingController.text);
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }
}

class Category {
  final String title;
  final List<String> selections;

  Category({@required this.title, this.selections});
}

void _pushScreen({BuildContext context, Widget screen}) {
  ThemeData themeData = Theme.of(context);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Theme(data: themeData, child: screen),
    ),
  );
}

class Product {
  final String name;
  final List<String> imageUrls;
  final double cost;
  final String description;
  final List<String> sizes;
  final Category category;
  final String productType;

  Product(
      {this.name,
      this.imageUrls,
      this.cost,
      this.description,
      this.sizes,
      this.category,
      this.productType});
}

class Cart with ChangeNotifier {
  List<OrderItem> itemsInCart = [];

  double get totalCost {
    double total = 0;
    itemsInCart.forEach((item) {
      total += item.product.cost;
    });
    return total;
  }

  void add(OrderItem orderItem) {
    itemsInCart.add(orderItem);
    notifyListeners();
  }

  void remove(OrderItem orderItem) {
    print(orderItem.product.name);
    var t = itemsInCart.remove(orderItem);
    print(t);
    notifyListeners();
  }
}

class OrderItem {
  Product product;
  String selectedSize;
  String selectedColor;

  OrderItem({@required this.product, this.selectedSize, this.selectedColor});
}

Category mensCategory = Category(title: "Men", selections: [
  "Shirts",
  "Jeans",
  "Shorts",
]);
Category womensCategory = Category(title: "Women", selections: [
  "Shirts",
  "Jeans",
]);
Category petsCategory = Category(title: "Pets", selections: [
  "Toys",
  "Treats",
]);

final kGreyBackground = Colors.grey[200];

List<Product> products = [
  Product(
      name: "2-Pack Crewneck T-Shirts - Black",
      imageUrls: [
        "https://images-na.ssl-images-amazon.com/images/I/91ieWhKe9AL._AC_UX569_.jpg",
        "https://images-na.ssl-images-amazon.com/images/I/71UqhKT2MDL._AC_UX466_.jpg",
        "https://images-na.ssl-images-amazon.com/images/I/81K7OAepB9L._AC_UX466_.jpg",
        "https://images-na.ssl-images-amazon.com/images/I/812T%2Bu00R4L._AC_UX466_.jpg"
      ],
      cost: 129900,
      category: mensCategory,
      productType: "shirts",
      sizes: ["S", "M", "L", "XL"]),
  Product(
    name: "Short Sleeve Henley - Blue",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/81tpGc13OgL._AC_UX522_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/81oNSlos2tL._AC_UY679_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/819ea2vQIjL._AC_UY679_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/91SH0RB-8dL._AC_UY606_.jpg"
    ],
    cost: 179900,
    category: mensCategory,
    productType: "shirts",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "Polo RL V-Neck",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/61m68nuygSL._AC_UX522_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/61URnzIoCPL._AC_UX522_.jpg",
    ],
    cost: 249900,
    category: mensCategory,
    productType: "shirts",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "Athletic-Fit Stretch Jeans",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/91SIuLNN%2BlL._AC_UY679_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/91Qpp%2BRPLtL._AC_UX522_.jpg",
    ],
    cost: 299900,
    category: mensCategory,
    productType: "jeans",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "Levi's Original Jeans",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/91L4zjZKF-L._AC_UX522_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/91Mf37jbSvL._AC_UX522_.jpg",
    ],
    cost: 399900,
    category: mensCategory,
    productType: "jeans",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "2-Pack Performance Shorts",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/A1lTY32j6gL._AC_UX679_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/71JYOHJ%2BS-L._AC_UX522_.jpg",
    ],
    cost: 199900,
    category: mensCategory,
    productType: "shorts",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "Levi's Cargo Shorts",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/915Io2JEUPL._AC_UX679_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/91WJgn0FNkL._AC_UX679_.jpg",
    ],
    cost: 299900,
    category: mensCategory,
    productType: "shorts",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "2-Pack Short-Sleeve Crewneck",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/911mb8PkHSL._AC_UX522_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/81LDpImWPAL._AC_UX522_.jpg",
    ],
    cost: 169900,
    category: womensCategory,
    productType: "shirts",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "Waffle Knit Tunic Blouse",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/71lDML8KDQL._AC_UX522_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/61Ojm-DnojL._AC_UY679_.jpg",
    ],
    cost: 229900,
    category: womensCategory,
    productType: "shirts",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "Mid-Rise Skinny Jeans",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/71canaWSlAL._AC_UX522_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/71zLzCwbXUL._AC_UX522_.jpg",
    ],
    cost: 289900,
    category: womensCategory,
    productType: "jeans",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "Levi's Straight 505 Jeans",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/51D4eXuwKaL._AC_UX679_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/51sHwN6mDzL._AC_UX679_.jpg",
    ],
    cost: 349900,
    category: womensCategory,
    productType: "jeans",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "Levi's 715 Bootcut Jeans",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/81QwSgeXHTL._AC_UX522_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/81qmkt1Be0L._AC_UY679_.jpg",
    ],
    cost: 349900,
    category: womensCategory,
    productType: "jeans",
    sizes: ["XS", "S", "M", "L", "XL"],
  ),
  Product(
    name: "3-Pack - Squeaky Plush Dog Toy",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/712YaF31-3L._AC_SL1000_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/71K1NzmHCfL._AC_SL1000_.jpg",
    ],
    cost: 99900,
    category: petsCategory,
    productType: "toys",
  ),
  Product(
    name: "Wobble Wag Giggle Ball",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/81XyqDXVwCL._AC_SX355_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/81Ye9KrP3pL._AC_SY355_.jpg",
    ],
    cost: 119900,
    category: petsCategory,
    productType: "toys",
  ),
  Product(
    name: "Duck Hide Twists",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/51dS9c0xIdL._SX342_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/81z4lvRtc5L._SL1500_.jpg",
    ],
    cost: 89900,
    category: petsCategory,
    productType: "treats",
  ),
  Product(
    name: "Zuke's Mini Training Treats",
    imageUrls: [
      "https://images-na.ssl-images-amazon.com/images/I/81LV2CHtGKL._AC_SY355_.jpg",
      "https://images-na.ssl-images-amazon.com/images/I/81K30Bs9C6L._AC_SY355_.jpg",
    ],
    cost: 109900,
    category: petsCategory,
    productType: "treats",
  ),
];
