import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/agent_repository.dart';
import 'agent_event.dart';
import 'agent_state.dart';

class AgentBloc extends Bloc<AgentEvent, AgentState> {
  final AgentRepository repository;

  AgentBloc({required this.repository}) : super(AgentInitial()) {
    on<LoadAgents>((event, emit) async {
      emit(AgentLoading());
      try {
        final agents = await repository.getAgents();
        emit(AgentLoaded(agents));
      } catch (e) {
        emit(AgentError(e.toString()));
      }
    });

    on<AddAgent>((event, emit) async {
      try {
        await repository.addAgent(event.agent, event.password);
        add(LoadAgents());
      } catch (e) {
        emit(AgentError(e.toString()));
      }
    });

    on<DeleteAgent>((event, emit) async {
      try {
        await repository.deleteAgent(event.uid);
        add(LoadAgents());
      } catch (e) {
        emit(AgentError(e.toString()));
      }
    });
  }
}