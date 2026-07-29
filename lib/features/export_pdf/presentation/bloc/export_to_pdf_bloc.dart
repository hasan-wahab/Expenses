import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/extensions/date_extension.dart';
import 'package:expense_app/core/utils/period_filtering_utils.dart';
import 'package:expense_app/features/export_pdf/domain/usescases/export_to_pdf_usecases.dart';
import 'export_to_pdf_events.dart';
import 'export_to_pdf_states.dart';

class ExportToPdfBloc extends Bloc<ExportPdfEvents, ExportToPdfStates> {
  ExportToPdfUseCases useCases;
  ExportToPdfBloc({required this.useCases})
    : super(GetExpenseByPeriod(status: Status.initial, pdfBytes: null)) {
    on<ExportToPdfEvent>(_onExportToPdfEvents);
    on<GetAllPropertyCardEvent>(_onGetAllPropertyCardEvent);
    on<DownloadPdfEvent>(_onDownloadPdfEvent);
  }

  FutureOr<void> _onExportToPdfEvents(
    ExportToPdfEvent event,
    Emitter<ExportToPdfStates> emit,
  ) async {
    try {
      emit(GetExpenseByPeriod(status: Status.loading));
      switch (event.mode) {
        case ExportToPdfMode.thisMonth:
          final thisMonth = PeriodFilteringUtils().thisMonth();
          final pdfBytes = await useCases.exportToPdfCall(
            propertyCardId: event.propertyCardId,
            startDate: thisMonth.startDate,
            endDate: thisMonth.endDate,
            propertyName: event.propertyName,
            location: event.location,
            reportingPeriod:
                "${thisMonth.startDate.toDisplayDate()}  To  ${thisMonth.endDate.toDisplayDate()}",
          );
          emit(GetExpenseByPeriod(status: Status.success, pdfBytes: pdfBytes));
          break;
        case ExportToPdfMode.lastQuarter:
          final lastQuarter = PeriodFilteringUtils().lastQuarter();

          final pdfBytes = await useCases.exportToPdfCall(
            propertyCardId: event.propertyCardId,
            startDate: lastQuarter.startDate,
            endDate: lastQuarter.endDate,
            propertyName: event.propertyName,
            location: event.location,
            reportingPeriod:
                "${lastQuarter.startDate!.toDisplayDate()}  To  ${lastQuarter.endDate!.toDisplayDate()}",
          );
          emit(GetExpenseByPeriod(status: Status.success, pdfBytes: pdfBytes));
          break;
        case ExportToPdfMode.customRange:
          final customRange = PeriodFilteringUtils().customRange(
            start: event.startDate!,
            end: event.endDate!,
          );

          final pdfBytes = await useCases.exportToPdfCall(
            propertyCardId: event.propertyCardId,
            startDate: customRange.startDate,
            endDate: customRange.endDate,
            propertyName: event.propertyName,
            location: event.location,
            reportingPeriod:
                "${event.startDate!.toDisplayDate()}  To  ${event.endDate!.toDisplayDate()}",
          );
          emit(GetExpenseByPeriod(status: Status.success, pdfBytes: pdfBytes));
          break;
      }
    } catch (e) {
      emit(GetExpenseByPeriod(status: Status.error, message: e.toString()));
    }
  }

  FutureOr<void> _onGetAllPropertyCardEvent(
    GetAllPropertyCardEvent event,
    Emitter<ExportToPdfStates> emit,
  ) async {
    try {
      emit(GetAllPropertyCard(status: Status.loading));
      final cardEntities = await useCases.getAllPropertyCardCall();

      emit(
        GetAllPropertyCard(status: Status.success, cardEntities: cardEntities),
      );
    } catch (e) {
      emit(
        GetAllPropertyCard(
          status: Status.error,
          message: e.toString(),
          cardEntities: [],
        ),
      );
    }
  }

  FutureOr<void> _onDownloadPdfEvent(
    DownloadPdfEvent event,
    Emitter<ExportToPdfStates> emit,
  ) async {
    try {
      emit(DownloadPdfState(status: Status.loading));
      await Future.delayed(const Duration(seconds: 2));
      await useCases.downloadPdfCall(
        pdfBytes: event.pdfBytes,
        propertyName: event.propertyName,
      );
      emit(
        DownloadPdfState(
          status: Status.success,
          message: '${event.propertyName} downloaded successfully',
        ),
      );
    } catch (e) {
      emit(DownloadPdfState(status: Status.error, message: e.toString()));
    }
  }
}
