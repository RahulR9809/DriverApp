import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'animation_state_event.dart';
part 'animation_state_state.dart';

class AnimationStateBloc extends Bloc<AnimationStateEvent, AnimationState> {
  AnimationStateBloc() : super(AnimationState(isAnimationComplete: false)) {
    on<AnimationCompleted>(_onAnimationCompleted);
    on<ResetAnimation>(_onResetAnimation);
  }

  void _onAnimationCompleted(AnimationCompleted event, Emitter<AnimationState> emit) {
    if (kDebugMode) {
      print('AnimationCompleted event received');
    }
    emit(state.copyWith(isAnimationComplete: true));
    if (kDebugMode) {
      print('Animation completed: ${state.isAnimationComplete}');
    }
  }

  void _onResetAnimation(ResetAnimation event, Emitter<AnimationState> emit) {
    if (kDebugMode) {
      print('ResetAnimation event received');
    }
    emit(state.copyWith(isAnimationComplete: false));
    if (kDebugMode) {
      print('Animation reset: ${state.isAnimationComplete}');
    }
  }
}
