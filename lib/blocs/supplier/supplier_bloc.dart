import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/supplier_model.dart';
import '../../data/repositories/supplier_repository.dart';

part 'supplier_event.dart';
part 'supplier_state.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final SupplierRepository supplierRepository;

  SupplierBloc({required this.supplierRepository}) : super(SupplierInitial()) {
    on<LoadSuppliers>(_onLoadSuppliers);
    on<SearchSuppliers>(_onSearchSuppliers);
    on<AddSupplier>(_onAddSupplier);
    on<UpdateSupplier>(_onUpdateSupplier);
    on<DeleteSupplier>(_onDeleteSupplier);
    on<LoadTopSuppliers>(_onLoadTopSuppliers);
  }

  void _onLoadSuppliers(LoadSuppliers event, Emitter<SupplierState> emit) {
    emit(SuppliersLoadInProgress());
    try {
      final suppliersStream = supplierRepository.getSuppliers(event.userId);
      emit(SuppliersLoadSuccess(suppliersStream: suppliersStream));
    } catch (e) {
      emit(SuppliersLoadFailure(error: e.toString()));
    }
  }

  void _onSearchSuppliers(SearchSuppliers event, Emitter<SupplierState> emit) {
    emit(SuppliersLoadInProgress());
    try {
      final suppliersStream = supplierRepository.searchSuppliers(
        event.userId,
        event.query,
      );
      emit(SuppliersLoadSuccess(suppliersStream: suppliersStream));
    } catch (e) {
      emit(SuppliersLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onAddSupplier(
    AddSupplier event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      await supplierRepository.addSupplier(event.supplier);
      // Suppliers will be updated via stream
    } catch (e) {
      emit(SupplierOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateSupplier(
    UpdateSupplier event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      await supplierRepository.updateSupplier(event.supplier);
    } catch (e) {
      emit(SupplierOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteSupplier(
    DeleteSupplier event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      await supplierRepository.deleteSupplier(event.supplierId);
    } catch (e) {
      emit(SupplierOperationFailure(error: e.toString()));
    }
  }

  void _onLoadTopSuppliers(
    LoadTopSuppliers event,
    Emitter<SupplierState> emit,
  ) {
    emit(SuppliersLoadInProgress());
    try {
      final suppliersStream = supplierRepository.getTopSuppliers(
        event.userId,
        limit: event.limit,
      );
      emit(SuppliersLoadSuccess(suppliersStream: suppliersStream));
    } catch (e) {
      emit(SuppliersLoadFailure(error: e.toString()));
    }
  }
}
