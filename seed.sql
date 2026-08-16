-- テスト用データ(lab_results_n8n.db)
-- kensa-kekka-ai の save.py が作るスキーマと同一。
-- n8n監視ワークフロー(/trend_n8n)は「最新値が基準値外の項目だけ」を対象にするため、
-- 慢性的な異常・新規の異常・正常(除外される)の3パターンを用意している。
-- すべて帳票基準値(reference列)による判定のみを使う、一般的な健康診断項目を選んでいる。
-- 実患者データは含まない。すべて動作確認用のダミー値。

CREATE TABLE IF NOT EXISTS lab_results (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    exam_date     TEXT NOT NULL,
    exam_time     TEXT NOT NULL,
    dialysis_type TEXT,
    name          TEXT NOT NULL,
    result        REAL,
    result_text   TEXT,
    unit          TEXT,
    reference     TEXT,
    UNIQUE(exam_date, exam_time, name)
);

-- 総コレステロール: 帳票基準値(140〜219)に対して常に高値 → 「慢性的に基準値外」
INSERT INTO lab_results (exam_date, exam_time, name, result, result_text, unit, reference) VALUES
('2026-05-01', '09:00', '総コレステロール', 230.0, '230', 'mg/dL', '140~219'),
('2026-06-01', '09:00', '総コレステロール', 235.0, '235', 'mg/dL', '140~219'),
('2026-07-01', '09:00', '総コレステロール', 240.0, '240', 'mg/dL', '140~219'),
('2026-08-01', '09:00', '総コレステロール', 245.0, '245', 'mg/dL', '140~219');

-- 白血球数: 帳票基準値(3500〜9000)を今回はじめて下回る → 新規の低下アラート
INSERT INTO lab_results (exam_date, exam_time, name, result, result_text, unit, reference) VALUES
('2026-05-01', '09:00', '白血球数', 6000, '6000', '/μL', '3500~9000'),
('2026-06-01', '09:00', '白血球数', 5000, '5000', '/μL', '3500~9000'),
('2026-07-01', '09:00', '白血球数', 4200, '4200', '/μL', '3500~9000'),
('2026-08-01', '09:00', '白血球数', 3200, '3200', '/μL', '3500~9000');

-- 中性脂肪: 帳票基準値(50〜149)で判定 → 今回はじめて上振れ
INSERT INTO lab_results (exam_date, exam_time, name, result, result_text, unit, reference) VALUES
('2026-05-01', '09:00', '中性脂肪', 100.0, '100', 'mg/dL', '50~149'),
('2026-06-01', '09:00', '中性脂肪', 120.0, '120', 'mg/dL', '50~149'),
('2026-07-01', '09:00', '中性脂肪', 140.0, '140', 'mg/dL', '50~149'),
('2026-08-01', '09:00', '中性脂肪', 160.0, '160', 'mg/dL', '50~149');

-- 血糖: 常に範囲内 → 通知対象から除外されることの確認用
INSERT INTO lab_results (exam_date, exam_time, name, result, result_text, unit, reference) VALUES
('2026-05-01', '09:00', '血糖', 85.0, '85', 'mg/dL', '70~109'),
('2026-06-01', '09:00', '血糖', 88.0, '88', 'mg/dL', '70~109'),
('2026-07-01', '09:00', '血糖', 90.0, '90', 'mg/dL', '70~109'),
('2026-08-01', '09:00', '血糖', 92.0, '92', 'mg/dL', '70~109');
