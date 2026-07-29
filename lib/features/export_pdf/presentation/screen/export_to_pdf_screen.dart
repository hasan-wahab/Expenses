import 'dart:async';
import 'dart:typed_data';

import 'package:expense_app/core/constant/const_text/export_pdf_text.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/core/utils/property_report_pdf_builder.dart';
import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:expense_app/features/add_expenses/presentation/widgets/property_card_dropdown.dart';
import 'package:expense_app/features/export_pdf/presentation/bloc/export_to_pdf_bloc.dart';
import 'package:expense_app/features/export_pdf/presentation/screen/pdf_preview_screen.dart';
import 'package:expense_app/features/export_pdf/presentation/widgets/selection_period_card.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/constant/wrapers.dart';
import '../../../../core/di/get_it.dart';
import '../../../dashboard/domain/entitity/dashboard_card_entity.dart';
import '../bloc/export_to_pdf_events.dart';
import '../bloc/export_to_pdf_states.dart';
import '../widgets/header_card.dart';
import '../widgets/preview_card.dart';

class ExportToPdfScreen extends StatefulWidget {
  const ExportToPdfScreen({super.key});

  @override
  State<ExportToPdfScreen> createState() => _ExportToPdfScreenState();
}

class _ExportToPdfScreenState extends State<ExportToPdfScreen> {
  List<DashboardCardEntity> cardEntities = [];
  String? selectedCardId;
  String? selectedPropertyName;
  String? selectedCardLocation;
  FutureOr<Uint8List>? pdfBytes;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ExportToPdfBloc>()..add(GetAllPropertyCardEvent()),
      child: BlocConsumer<ExportToPdfBloc, ExportToPdfStates>(
        listener: (context, state) {
          if (state is GetExpenseByPeriod) {
            switch (state.status) {
              case Status.loading:
                context.showCustomLoading();
                break;
              case Status.success:
                context.pop();

                pdfBytes = state.pdfBytes;
                if (pdfBytes != null) {
                  context.push(
                    RoutesName.pdfPreviewScreen,
                    extra: PdfPreviewArgs(
                      build: (format) async => pdfBytes!,
                      propertyName: cardEntities.first.propertyName.toString(),
                    ),
                  );
                }

                break;
              case Status.error:
                context.pop();
                context.showSnackBar(state.message, isError: true);
                break;
              default:
            }
          }
          if (state is GetAllPropertyCard) {
            switch (state.status) {
              case Status.loading:
                context.showCustomLoading();
                break;
              case Status.success:
                context.pop();
                setState(() {
                  cardEntities = state.cardEntities!;
                });
                break;
              case Status.error:
                context.pop();
                context.showSnackBar(state.message, isError: true);
                break;
              default:
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: ExportPdfText.export),
            body: ListView(
              padding: .symmetric(horizontal: 20.w),
              children: [
                SizedBox(height: 24.h),
                HeaderCard(),
                SizedBox(height: 24.h),
                PropertyCardDropdown(
                  propertyCardId: selectedCardId,
                  onSelected: (String? value) {
                    for (var a in cardEntities) {
                      if (a.cardId.toString() == value) {
                        selectedCardLocation = a.propertyLocation;
                        selectedPropertyName = a.propertyName;
                        selectedCardId = a.cardId.toString();
                        break;
                      }
                    }
                    setState(() {});
                  },
                  dashboardCardList: cardEntities,
                ),
                SizedBox(height: 24.h),
                SelectionPeriodCard(
                  propertyCardId: selectedCardId ?? '',
                  location: selectedCardLocation ?? '',
                  propertyName: selectedPropertyName ?? '',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
