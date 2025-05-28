import '../../data/model/agent_model.dart';

abstract class AgentEvent {}

class LoadAgents extends AgentEvent {}

class AddAgent extends AgentEvent {
  final AgentModel agent;
  final String password;
  AddAgent(this.agent, this.password);
}

class DeleteAgent extends AgentEvent {
  final String uid;
  DeleteAgent(this.uid);
}