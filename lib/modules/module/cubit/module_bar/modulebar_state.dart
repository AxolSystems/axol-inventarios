import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ModuleBarState extends Equatable {
  const ModuleBarState();
}

class InitialModuleBarState extends ModuleBarState {
  @override
  List<Object?> get props => [];
}

class LoadingModuleBarState extends ModuleBarState {
  @override
  List<Object?> get props => [];
}

class LoadedModuleBarState extends ModuleBarState {
  final Color? color;
  const LoadedModuleBarState({this.color});
  @override
  List<Object?> get props => [color];
}

class ErrorModuleBarState extends ModuleBarState {
  final String error;
  const ErrorModuleBarState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}