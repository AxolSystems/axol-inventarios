import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/theme.dart';

abstract class PopupMenuAxolState extends Equatable {
  const PopupMenuAxolState();
}

class InitialPopupMenuState extends PopupMenuAxolState {
  @override
  List<Object?> get props => [];
}

class LoadingPopupMenuState extends PopupMenuAxolState {
  @override
  List<Object?> get props => [];
}

class LoadedPopupMenuState extends PopupMenuAxolState {
  final bool? isHover;
  const LoadedPopupMenuState({this.isHover});
  @override
  List<Object?> get props => [isHover];
}

class ErrorPopunMenuState extends PopupMenuAxolState {
  final String error;
  const ErrorPopunMenuState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}

class PopupMenuBtnAxolCubit extends Cubit<PopupMenuAxolState> {
  PopupMenuBtnAxolCubit() : super(InitialPopupMenuState());

  Future<void> initLoad() async {
    try {
      emit(InitialPopupMenuState());
      emit(LoadingPopupMenuState());
      emit(const LoadedPopupMenuState());
    } catch (e) {
      emit(InitialPopupMenuState());
      emit(ErrorPopunMenuState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialPopupMenuState());
      emit(LoadingPopupMenuState());

      emit(const LoadedPopupMenuState());
    } catch (e) {
      emit(InitialPopupMenuState());
      emit(ErrorPopunMenuState(error: e.toString()));
    }
  }

  Future<void> setHover(bool isHover) async {
    try {
      emit(InitialPopupMenuState());
      emit(LoadingPopupMenuState());

      emit(LoadedPopupMenuState(isHover: isHover));
    } catch (e) {
      emit(InitialPopupMenuState());
      emit(ErrorPopunMenuState(error: e.toString()));
    }
  }
}

class PopupMenuBtnAxol extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final List<PopupMenuEntry<int>>? entryList;
  final int theme;
  const PopupMenuBtnAxol(
      {super.key, this.icon, this.text, this.entryList, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PopupMenuBtnAxolCubit(),
      child: PopupMenuBtnAxolBuild(
        icon: icon,
        text: text,
        entryList: entryList,
        theme: theme,
      ),
    );
  }
}

class PopupMenuBtnAxolBuild extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final List<PopupMenuEntry<int>>? entryList;
  final int theme;
  const PopupMenuBtnAxolBuild(
      {super.key, this.icon, this.text, this.entryList, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopupMenuBtnAxolCubit, PopupMenuAxolState>(
        builder: (context, state) {
      final bool isHover;
      if (state is LoadedPopupMenuState) {
        isHover = state.isHover ?? false;
      } else {
        isHover = false;
      }
      return SizedBox(
        height: 24,
        child: PopupMenuButton(
            tooltip: '',
            color: ColorTheme.item40(theme),
            itemBuilder: (context) => entryList ?? [],
            child: MouseRegion(
              onEnter: (event) {
                context.read<PopupMenuBtnAxolCubit>().setHover(true);
              },
              onExit: (event) {
                context.read<PopupMenuBtnAxolCubit>().setHover(false);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: isHover
                        ? ColorTheme.item30(theme)
                        : ColorTheme.background(theme),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    Visibility(
                      visible: icon != null,
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: isHover
                            ? ColorTheme.text(theme)
                            : ColorPalette.middleItems,
                      ),
                    ),
                    Visibility(
                      visible: icon != null && text != null,
                      child: const SizedBox(width: 8),
                    ),
                    Visibility(
                        visible: text != null,
                        child: SizedBox(
                          width: 147,
                          child: Text(
                            text ?? '',
                            textAlign: TextAlign.start,
                            style: isHover ? Typo.system(theme) : Typo.systemMidle,
                          ),
                        ))
                  ],
                ),
              ),
            )),
      );
    });
  }
}
