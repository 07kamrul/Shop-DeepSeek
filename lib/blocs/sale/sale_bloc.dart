import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/sale_model.dart';
import '../../data/repositories/sale_repository.dart';

part 'sale_event.dart';
part 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  final SaleRepository saleRepository;

  SaleBloc({required this.saleRepository}) : super(SaleInitial()) {
    on<LoadSales>(_onLoadSales);
    on<LoadSalesByDateRange>(_onLoadSalesByDateRange);
    on<LoadTodaySales>(_onLoadTodaySales);
    on<AddSale>(_onAddSale);
    on<DeleteSale>(_onDeleteSale);
  }

  void _onLoadSales(LoadSales event, Emitter<SaleState> emit) {
    emit(SalesLoadInProgress());
    try {
      final salesStream = saleRepository.getSales(event.userId);
      emit(SalesLoadSuccess(salesStream: salesStream));
    } catch (e) {
      emit(SalesLoadFailure(error: e.toString()));
    }
  }

  void _onLoadSalesByDateRange(
    LoadSalesByDateRange event,
    Emitter<SaleState> emit,
  ) {
    emit(SalesLoadInProgress());
    try {
      final salesStream = saleRepository.getSalesByDateRange(
        event.userId,
        event.startDate,
        event.endDate,
      );
      emit(SalesLoadSuccess(salesStream: salesStream));
    } catch (e) {
      emit(SalesLoadFailure(error: e.toString()));
    }
  }

  void _onLoadTodaySales(LoadTodaySales event, Emitter<SaleState> emit) {
    emit(SalesLoadInProgress());
    try {
      final salesStream = saleRepository.getTodaySales(event.userId);
      emit(SalesLoadSuccess(salesStream: salesStream));
    } catch (e) {
      emit(SalesLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onAddSale(AddSale event, Emitter<SaleState> emit) async {
    emit(SaleOperationInProgress());
    try {
      await saleRepository.addSale(event.sale);
      emit(SaleOperationSuccess());
    } catch (e) {
      emit(SaleOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteSale(DeleteSale event, Emitter<SaleState> emit) async {
    emit(SaleOperationInProgress());
    try {
      await saleRepository.deleteSale(event.sale);
      emit(SaleOperationSuccess());
    } catch (e) {
      emit(SaleOperationFailure(error: e.toString()));
    }
  }
}
