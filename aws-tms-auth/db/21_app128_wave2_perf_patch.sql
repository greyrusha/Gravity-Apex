-- 21_app128_wave2_perf_patch.sql
-- Surgical Wave 2 performance & consolidation patch for App 128:
--   Page 60 (replace WSH_DELIVERY_ASSIGNMENTS_V view with base table WSH_DELIVERY_ASSIGNMENTS + type filter)
--   Page 61 (consolidate inline dynamic SQL/PLSQL into XXME_INV_PENDING_UI_PKG)
--   Page 70 (consolidate Process Monitor CA/RV/RS/Summary/Filters into XXME_PROCESS_MONITOR_PKG)
--   Pages 71 & 72 (consolidate Fixed Assets close, bridge, asset details & GL lines into XXME_FA_CLOSE_PKG)
@@wave2_app128/f128.sql
