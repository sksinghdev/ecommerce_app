// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:dio/dio.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:get_it/get_it.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// final GetIt locator = GetIt.instance;

// void setupLocator() {
//   locator.registerLazySingleton(() => ProductListProvider());
//   locator.registerLazySingleton(() => CartProvider());
//   locator.registerLazySingleton(() => AuthCubit());
//   locator.registerLazySingleton(() => NetworkCubit());
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   setupLocator();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);

//   final _appRouter = AppRouter();

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider.value(value: locator<ProductListProvider>()),
//         ChangeNotifierProvider.value(value: locator<CartProvider>()),
//       ],
//       child: BlocProvider.value(
//         value: locator<AuthCubit>(),
//         child: BlocProvider.value(
//           value: locator<NetworkCubit>(),
//           child: MaterialApp.router(
//             routerDelegate: _appRouter.delegate(),
//             routeInformationParser: _appRouter.defaultRouteParser(),
//             debugShowCheckedModeBanner: false,
//             title: 'E-Commerce App',
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//               visualDensity: VisualDensity.adaptivePlatformDensity,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// @AutoRouterConfig()
// class AppRouter extends $AppRouter {
//   @override
//   List<AutoRoute> get routes => [
//     AutoRoute(page: AuthWrapperRoute.page, initial: true),
//     AutoRoute(page: LoginRoute.page),
//     AutoRoute(page: ProductListRoute.page),
//     AutoRoute(page: ProductDetailsRoute.page),
//     AutoRoute(page: CartRoute.page),
//     AutoRoute(page: PaymentRoute.page),
//   ];
// }

// @RoutePage()
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NetworkCubit, NetworkState>(
//       builder: (context, networkState) {
//         if (networkState is NetworkDisconnected) {
//           return const Scaffold(
//             body: Center(child: Text('No internet connection!')),
//           );
//         }
//         return BlocBuilder<AuthCubit, AuthState>(
//           builder: (context, state) {
//             if (state is AuthLoggedInState) {
//               return const ProductListScreen();
//             } else if (state is AuthLoggedOutState) {
//               return const LoginPage();
//             } else if (state is AuthLoadingState) {
//               return const Scaffold(
//                 body: Center(child: CircularProgressIndicator()),
//               );
//             } else if (state is AuthErrorState) {
//               return Scaffold(
//                 body: Center(child: Text('Error: ${state.error}')),
//               );
//             }
//             return const Scaffold(
//               body: Center(child: Text('Something went wrong!')),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// // Auth Cubit
// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit() : super(AuthLoadingState()) {
//     _checkAuthState();
//   }

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   void _checkAuthState() {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       emit(AuthLoggedInState(user));
//     } else {
//       emit(AuthLoggedOutState());
//     }
//   }

//   Future<void> signUp({required String email, required String password}) async {
//     emit(AuthLoadingState());
//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       User? user = _auth.currentUser;
//       if (user != null) {
//         emit(AuthLoggedInState(user));
//       } else {
//         emit(AuthLoggedOutState());
//       }
//     } on FirebaseAuthException catch (e) {
//       emit(AuthErrorState(e.message.toString()));
//     }
//   }

//   Future<void> signIn({required String email, required String password}) async {
//     emit(AuthLoadingState());
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       User? user = _auth.currentUser;
//       if (user != null) {
//         emit(AuthLoggedInState(user));
//       } else {
//         emit(AuthLoggedOutState());
//       }
//     } on FirebaseAuthException catch (e) {
//       emit(AuthErrorState(e.message.toString()));
//     }
//   }

//   Future<void> signInWithGoogle() async {
//     emit(AuthLoadingState());
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       if (googleUser != null) {
//         final GoogleSignInAuthentication googleAuth =
//             await googleUser.authentication;

//         final OAuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );

//         await _auth.signInWithCredential(credential);

//         User? user = _auth.currentUser;
//         if (user != null) {
//           emit(AuthLoggedInState(user));
//         } else {
//           emit(AuthLoggedOutState());
//         }
//       } else {
//         emit(AuthLoggedOutState());
//       }
//     } catch (e) {
//       emit(AuthErrorState(e.toString()));
//     }
//   }

//   Future<void> signOut() async {
//     emit(AuthLoadingState());
//     await _auth.signOut();
//     emit(AuthLoggedOutState());
//   }
// }

// // Auth States
// abstract class AuthState {}

// class AuthLoadingState extends AuthState {}

// class AuthLoggedInState extends AuthState {
//   final User user;

//   AuthLoggedInState(this.user);
// }

// class AuthLoggedOutState extends AuthState {}

// class AuthErrorState extends AuthState {
//   final String error;

//   AuthErrorState(this.error);
// }

// // Network Cubit (in core/network)
// class NetworkCubit extends Cubit<NetworkState> {
//   NetworkCubit() : super(NetworkInitial()) {
//     _checkConnectivity();
//   }

//   final Connectivity _connectivity = Connectivity();

//   void _checkConnectivity() {
//     _connectivity.onConnectivityChanged.listen((connectivityResult) {
//       if (connectivityResult == ConnectivityResult.none) {
//         emit(NetworkDisconnected());
//       } else {
//         emit(NetworkConnected());
//       }
//     });
//   }
// }

// // Network States
// abstract class NetworkState {}

// class NetworkInitial extends NetworkState {}

// class NetworkConnected extends NetworkState {}

// class NetworkDisconnected extends NetworkState {}

// // Pages
// @RoutePage()
// class LoginPage extends StatelessWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController emailController = TextEditingController();
//     TextEditingController passwordController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(hintText: 'Email'),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(hintText: 'Password'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 locator<AuthCubit>().signIn(
//                   email: emailController.text.trim(),
//                   password: passwordController.text.trim(),
//                 );
//               },
//               child: const Text('Sign In'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 locator<AuthCubit>().signUp(
//                   email: emailController.text.trim(),
//                   password: passwordController.text.trim(),
//                 );
//               },
//               child: const Text('Sign Up'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 locator<AuthCubit>().signInWithGoogle();
//               },
//               child: const Text('Sign In with Google'),
//             ),
//             BlocBuilder<AuthCubit, AuthState>(
//               builder: (context, state) {
//                 if (state is AuthErrorState) {
//                   return Text(
//                     'Error: ${state.error}',
//                     style: const TextStyle(color: Colors.red),
//                   );
//                 } else {
//                   return const SizedBox.shrink();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// @RoutePage()
// class ProductListScreen extends StatefulWidget {
//   const ProductListScreen({Key? key}) : super(key: key);

//   @override
//   _ProductListScreenState createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       locator<ProductListProvider>().fetchProducts();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productListProvider = Provider.of<ProductListProvider>(context);
//     final cartProvider = Provider.of<CartProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Products'),
//         actions: [
//           ShoppingCartButton(
//             itemCount: cartProvider.cartItems.length,
//             onPressed: () {
//               AutoRouter.of(context).push(const CartRoute());
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.exit_to_app),
//             onPressed: () {
//               locator<AuthCubit>().signOut();
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<NetworkCubit, NetworkState>(
//         builder: (context, networkState) {
//           if (networkState is NetworkDisconnected) {
//             return const Center(child: Text('No internet connection!'));
//           }
//           return productListProvider.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : productListProvider.products.isEmpty
//               ? const Center(child: Text('No products found.'))
//               : Column(
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: productListProvider.products.length,
//                         itemBuilder: (context, index) {
//                           final product = productListProvider.products[index];
//                           return ProductCard(
//                             product: product,
//                             onAddToCart: () {
//                               cartProvider.addItem(product);
//                             },
//                             onTap: () {
//                               AutoRouter.of(
//                                 context,
//                               ).push(ProductDetailsRoute(product: product));
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                     CustomPagination(
//                       currentPage: productListProvider.currentPage,
//                       totalPages: productListProvider.totalPages,
//                       onPageChanged: (page) {
//                         productListProvider.goToPage(page);
//                       },
//                     ),
//                   ],
//                 );
//         },
//       ),
//     );
//   }
// }

// class ProductCard extends StatelessWidget {
//   final Product product;
//   final VoidCallback onAddToCart;
//   final VoidCallback onTap;

//   const ProductCard({
//     Key? key,
//     required this.product,
//     required this.onAddToCart,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         margin: const EdgeInsets.all(8.0),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.network(
//                 product.image,
//                 height: 100,
//                 width: double.infinity,
//                 fit: BoxFit.fitWidth,
//               ),
//               Text(
//                 product.title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text('\$${product.price.toStringAsFixed(2)}'),
//               ElevatedButton(
//                 onPressed: onAddToCart,
//                 child: const Text('Add to Cart'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ShoppingCartButton extends StatefulWidget {
//   final int itemCount;
//   final VoidCallback onPressed;

//   const ShoppingCartButton({
//     Key? key,
//     required this.itemCount,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   _ShoppingCartButtonState createState() => _ShoppingCartButtonState();
// }

// class _ShoppingCartButtonState extends State<ShoppingCartButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void didUpdateWidget(covariant ShoppingCartButton oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.itemCount != oldWidget.itemCount) {
//       _animationController.reset();
//       _animationController.forward();
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         ScaleTransition(
//           scale: _animation,
//           child: IconButton(
//             icon: const Icon(Icons.shopping_cart),
//             onPressed: widget.onPressed,
//           ),
//         ),
//         if (widget.itemCount > 0)
//           Positioned(
//             right: 5,
//             top: 5,
//             child: Container(
//               padding: const EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
//               child: Text(
//                 widget.itemCount.toString(),
//                 style: const TextStyle(color: Colors.white, fontSize: 10),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class CustomPagination extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final Function(int) onPageChanged;

//   const CustomPagination({
//     Key? key,
//     required this.currentPage,
//     required this.totalPages,
//     required this.onPageChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: currentPage > 1
//                 ? () => onPageChanged(currentPage - 1)
//                 : null,
//           ),
//           Text('Page $currentPage of $totalPages'),
//           IconButton(
//             icon: const Icon(Icons.arrow_forward),
//             onPressed: currentPage < totalPages
//                 ? () => onPageChanged(currentPage + 1)
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }
// }

// @RoutePage()
// class ProductDetailsScreen extends StatelessWidget {
//   final Product product;

//   const ProductDetailsScreen({Key? key, required this.product})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Product Details')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               product.image,
//               width: double.infinity,
//               height: 200,
//               fit: BoxFit.fitWidth,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               product.title,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '\$${product.price.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 18, color: Colors.green),
//             ),
//             const SizedBox(height: 16),
//             Text(product.description, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 24),
//             const Text(
//               'Related Products',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 150,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 5,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Image.network(
//                         "https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg",
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// @RoutePage()
// class CartScreen extends StatelessWidget {
//   const CartScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Cart')),
//       body: BlocBuilder<NetworkCubit, NetworkState>(
//         builder: (context, networkState) {
//           if (networkState is NetworkDisconnected) {
//             return const Center(child: Text('No internet connection!'));
//           }
//           return cartProvider.cartItems.isEmpty
//               ? const Center(child: Text('Your cart is empty.'))
//               : ListView.builder(
//                   itemCount: cartProvider.cartItems.length,
//                   itemBuilder: (context, index) {
//                     final item = cartProvider.cartItems[index];
//                     return ListTile(
//                       leading: Image.network(item.image, width: 50, height: 50),
//                       title: Text(item.title),
//                       subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.remove_shopping_cart),
//                         onPressed: () {
//                           cartProvider.removeItem(item);
//                         },
//                       ),
//                     );
//                   },
//                 );
//         },
//       ),
//       bottomNavigationBar: cartProvider.cartItems.isNotEmpty
//           ? Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   AutoRouter.of(context).push(const PaymentRoute());
//                 },
//                 child: const Text('Checkout'),
//               ),
//             )
//           : null,
//     );
//   }
// }

// @RoutePage()
// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({Key? key}) : super(key: key);

//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Payment')),
//       body: BlocBuilder<NetworkCubit, NetworkState>(
//         builder: (context, networkState) {
//           if (networkState is NetworkDisconnected) {
//             return const Center(child: Text('No internet connection!'));
//           }
//           return const Center(
//             child: Text(
//               "Payment processing not yet implemented. Please implement Stripe integration",
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // Data Models
// class Product {
//   final int id;
//   final String title;
//   final double price;
//   final String description;
//   final String category;
//   final String image;
//   final Rating rating;

//   Product({
//     required this.id,
//     required this.title,
//     required this.price,
//     required this.description,
//     required this.category,
//     required this.image,
//     required this.rating,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] as int,
//       title: json['title'] as String,
//       price: (json['price'] as num).toDouble(),
//       description: json['description'] as String,
//       category: json['category'] as String,
//       image: json['image'] as String,
//       rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
//     );
//   }
// }

// class Rating {
//   final double rate;
//   final int count;

//   Rating({required this.rate, required this.count});

//   factory Rating.fromJson(Map<String, dynamic> json) {
//     return Rating(
//       rate: (json['rate'] as num).toDouble(),
//       count: json['count'] as int,
//     );
//   }
// }

// // Providers
// class ProductListProvider extends ChangeNotifier {
//   final Dio _dio = Dio();
//   List<Product> _products = [];
//   bool _isLoading = false;
//   int _currentPage = 1;
//   int _totalPages = 1;
//   final int _limit = 10;

//   List<Product> get products => _products;
//   bool get isLoading => _isLoading;
//   int get currentPage => _currentPage;
//   int get totalPages => _totalPages;

//   Future<void> fetchProducts() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final response = await _dio.get(
//         'https://fakestoreapi.com/products?limit=$_limit&start=${(_currentPage - 1) * _limit}',
//       ); // Adjusted API call for pagination

//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data as List<dynamic>;
//         _products = data
//             .map((json) => Product.fromJson(json as Map<String, dynamic>))
//             .toList();
//         _totalPages = (data.length / _limit)
//             .ceil(); // Assuming the API returns all products (or at least enough) to calculate total pages
//         notifyListeners();
//       } else {
//         // Handle error
//         print('Failed to fetch products: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle error
//       print('Error fetching products: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> goToPage(int page) async {
//     if (page >= 1 && page <= _totalPages) {
//       _currentPage = page;
//       await fetchProducts();
//       notifyListeners();
//     }
//   }
// }

// class CartProvider extends ChangeNotifier {
//   final List<Product> _cartItems = [];

//   List<Product> get cartItems => _cartItems;

//   void addItem(Product product) {
//     _cartItems.add(product);
//     notifyListeners();
//   }

//   void removeItem(Product product) {
//     _cartItems.remove(product);
//     notifyListeners();
//   }
// }

// @RoutePage()
// class AuthWrapperRoute extends AutoRoute<dynamic> {
//   const AuthWrapperRoute({super.key});
// }

// @RoutePage()
// class LoginRoute extends AutoRoute<dynamic> {
//   const LoginRoute({super.key});
// }

// @RoutePage()
// class ProductListRoute extends AutoRoute<dynamic> {
//   const ProductListRoute({super.key});
// }

// @RoutePage()
// class ProductDetailsRoute extends AutoRoute<dynamic> {
//   const ProductDetailsRoute({super.key, required this.product});

//   final Product product;
// }

// @RoutePage()
// class CartRoute extends AutoRoute<dynamic> {
//   const CartRoute({super.key});
// }

// @RoutePage()
// class PaymentRoute extends AutoRoute<dynamic> {
//   const PaymentRoute({super.key});
// }

// class $AppRouter {}
