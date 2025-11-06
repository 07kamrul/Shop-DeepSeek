import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/report_model.dart';
import '../../data/repositories/report_repository.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;

  ReportBloc({required this.reportRepository}) : super(ReportInitial()) {
    on<LoadProfitLossReport>(_onLoadProfitLossReport);
    on<LoadDailySalesReport>(_onLoadDailySalesReport);
    on<LoadTopSellingProducts>(_onLoadTopSellingProducts);
  }

  Future<void> _onLoadProfitLossReport(
    LoadProfitLossReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoadInProgress());
    try {
      final report = await reportRepository.getProfitLossReport(
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(ProfitLossReportLoaded(report: report));
    } catch (e) {
      emit(ReportLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onLoadDailySalesReport(
    LoadDailySalesReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoadInProgress());
    try {
      final reports = await reportRepository.getDailySalesReport(
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(DailySalesReportLoaded(reports: reports));
    } catch (e) {
      emit(ReportLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onLoadTopSellingProducts(
    LoadTopSellingProducts event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoadInProgress());
    try {
      final products = await reportRepository.getTopSellingProducts(
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
        limit: event.limit,
      );
      emit(TopSellingProductsLoaded(products: products));
    } catch (e) {
      emit(ReportLoadFailure(error: e.toString()));
    }
  }
}
