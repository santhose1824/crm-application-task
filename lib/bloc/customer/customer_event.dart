import 'package:equatable/equatable.dart';
import '../../data/model/customer_model.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
  @override
  List<Object?> get props => [];
}

class LoadCustomers extends CustomerEvent {}

class AddCustomer extends CustomerEvent {
  final CustomerModel customer;
  const AddCustomer(this.customer);

  @override
  List<Object?> get props => [customer];
}

class UpdateCustomer extends CustomerEvent {
  final CustomerModel customer;
  const UpdateCustomer(this.customer);

  @override
  List<Object?> get props => [customer];
}

class DeleteCustomer extends CustomerEvent {
  final String uid;
  const DeleteCustomer(this.uid);

  @override
  List<Object?> get props => [uid];
}
