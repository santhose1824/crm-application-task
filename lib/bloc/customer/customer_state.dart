import 'package:equatable/equatable.dart';
import '../../data/model/customer_model.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();
  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<CustomerModel> customers;
  const CustomerLoaded(this.customers);

  @override
  List<Object?> get props => [customers];
}

class CustomerError extends CustomerState {
  final String message;
  const CustomerError(this.message);

  @override
  List<Object?> get props => [message];
}
