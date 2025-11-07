import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<UpdateProductStock>(_onUpdateProductStock);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) {
    emit(ProductsLoadInProgress());
    try {
      final productsStream = productRepository.getProducts();
      emit(ProductsLoadSuccess(productsStream: productsStream));
    } catch (e) {
      emit(ProductsLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    try {
      await productRepository.addProduct(event.product);
      // Products will be updated via stream
    } catch (e) {
      emit(ProductOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    try {
      await productRepository.updateProduct(event.product);
    } catch (e) {
      emit(ProductOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      await productRepository.deleteProduct(event.productId);
    } catch (e) {
      emit(ProductOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateProductStock(
      UpdateProductStock event, Emitter<ProductState> emit) async {
    try {
      await productRepository.updateStock(event.productId, event.newStock);
    } catch (e) {
      emit(ProductOperationFailure(error: e.toString()));
    }
  }
}