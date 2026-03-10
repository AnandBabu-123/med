import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/get_family_members_reposotory/get_family_members_reposotory.dart';
import 'get_family_members_event.dart';
import 'get_family_members_state.dart';

class GetFamilyMembersBloc
    extends Bloc<GetFamilyMembersEvent, GetFamilyMembersState> {

  final GetFamilyMembersRepository repository;

  GetFamilyMembersBloc(this.repository)
      : super(const GetFamilyMembersState()) {

    on<FetchFamilyMembersEvent>(_fetchMembers);
  }

  Future<void> _fetchMembers(
      FetchFamilyMembersEvent event,
      Emitter<GetFamilyMembersState> emit) async {

    try {

      emit(state.copyWith(loading: true));

      final data = await repository.getFamilyMembers();

      emit(state.copyWith(
        loading: false,
        members: data,
      ));

    } catch (e) {

      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }
}