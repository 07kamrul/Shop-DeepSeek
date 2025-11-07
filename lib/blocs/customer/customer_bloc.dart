import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/customer_model.dart';
import '../../data/repositories/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;

  CustomerBloc({required this.customerRepository}) : super(CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<SearchCustomers>(_onSearchCustomers);
    on<AddCustomer>(_onAddCustomer);
    on<UpdateCustomer>(_onUpdateCustomer);
    on<DeleteCustomer>(_onDeleteCustomer);
    on<LoadTopCustomers>(_onLoadTopCustomers);
  }

  void _onLoadCustomers(LoadCustomers event, Emitter<CustomerState> emit) {
    emit(CustomersLoadInProgress());
    try {
      final customersStream = customerRepository.getCustomers(event.userId);
      emit(CustomersLoadSuccess(customersStream: customersStream));
    } catch (e) {
      emit(CustomersLoadFailure(error: e.toString()));
    }
  }

  void _onSearchCustomers(SearchCustomers event, Emitter<CustomerState> emit) {
    emit(CustomersLoadInProgress());
    try {
      final customersStream = customerRepository.searchCustomers(
        event.userId,
        event.query,
      );
      emit(CustomersLoadSuccess(customersStream: customersStream));
    } catch (e) {
      emit(CustomersLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onAddCustomer(
    AddCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      await customerRepository.addCustomer(event.customer);
      // Customers will be updated via stream
    } catch (e) {
      emit(CustomerOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateCustomer(
    UpdateCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      await customerRepository.updateCustomer(event.customer);
    } catch (e) {
      emit(CustomerOperationFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteCustomer(
    DeleteCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      await customerRepository.deleteCustomer(event.customerId);
    } catch (e) {
      emit(CustomerOperationFailure(error: e.toString()));
    }
  }

  void _onLoadTopCustomers(
    LoadTopCustomers event,
    Emitter<CustomerState> emit,
  ) {
    emit(CustomersLoadInProgress());
    try {
      final customersStream = customerRepository.getTopCustomers(
        event.userId,
        limit: event.limit,
      );
      emit(CustomersLoadSuccess(customersStream: customersStream));
    } catch (e) {
      emit(CustomersLoadFailure(error: e.toString()));
    }
  }
}
