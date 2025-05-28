import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/customer_model.dart';
import '../../data/repository/customer_repository.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository repository;

  CustomerBloc({required this.repository}) : super(CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<AddCustomer>(_onAddCustomer);
    on<UpdateCustomer>(_onUpdateCustomer);
    on<DeleteCustomer>(_onDeleteCustomer);
  }

  Future<void> _onLoadCustomers(LoadCustomers event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      final customers = await repository.getCustomers();
      emit(CustomerLoaded(customers));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onAddCustomer(AddCustomer event, Emitter<CustomerState> emit) async {
    try {
      await repository.addCustomer(event.customer);
      add(LoadCustomers());
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onUpdateCustomer(UpdateCustomer event, Emitter<CustomerState> emit) async {
    try {
      await repository.updateCustomer(event.customer);
      add(LoadCustomers());
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onDeleteCustomer(DeleteCustomer event, Emitter<CustomerState> emit) async {
    try {
      await repository.deleteCustomer(event.uid);
      add(LoadCustomers());
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }
}
