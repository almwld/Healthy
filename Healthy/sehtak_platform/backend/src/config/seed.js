const bcrypt = require('bcryptjs');
const pool = require('./db');

async function seed() {
  try {
    // Hash passwords
    const pass1 = await bcrypt.hash('Password123', 10);
    const pass2 = await bcrypt.hash('Doctor123', 10);
    const pass3 = await bcrypt.hash('Pharmacy123', 10);
    const pass4 = await bcrypt.hash('Patient123', 10);

    // 6 Patients
    await pool.query(`
      INSERT INTO users (id, full_name, phone, email, password_hash, user_type, is_verified) VALUES
      ('a1111111-1111-1111-1111-111111111111', '\u0623\u062d\u0645\u062f \u0645\u062d\u0645\u062f \u0627\u0644\u0633\u0644\u0645\u0627\u0646', '+966501234567', 'ahmed@email.com', '${pass4}', 'patient', true),
      ('a2222222-2222-2222-2222-222222222222', '\u0641\u0627\u0637\u0645\u0629 \u0639\u0644\u064a \u0627\u0644\u0631\u062d\u0628\u064a', '+966509876543', 'fatima@email.com', '${pass4}', 'patient', true),
      ('a3333333-3333-3333-3333-333333333333', '\u062e\u0627\u0644\u062f \u0639\u0628\u062f\u0627\u0644\u0644\u0647 \u0627\u0644\u063a\u0627\u0645\u062f\u064a', '+966555555555', 'khaled@email.com', '${pass4}', 'patient', true),
      ('a4444444-4444-4444-4444-444444444444', '\u0646\u0648\u0631\u0627 \u0633\u0639\u064a\u062f \u0627\u0644\u0647\u0627\u0634\u0645\u064a', '+966566666666', 'nora@email.com', '${pass4}', 'patient', true),
      ('a5555555-5555-5555-5555-555555555555', '\u0633\u0639\u0648\u062f \u0641\u0647\u062f \u0627\u0644\u0645\u0637\u064a\u0631\u064a', '+966577777777', 'saud@email.com', '${pass4}', 'patient', true),
      ('a6666666-6666-6666-6666-666666666666', '\u0645\u0646\u0627\u0631\u0629 \u0627\u0644\u0634\u0645\u0631\u064a', '+966588888888', 'manara@email.com', '${pass4}', 'patient', true)
      ON CONFLICT DO NOTHING;
    `);

    // 2 Doctors
    await pool.query(`
      INSERT INTO users (id, full_name, phone, email, password_hash, user_type, is_verified) VALUES
      ('b1111111-1111-1111-1111-111111111111', '\u062f. \u0645\u062d\u0645\u062f \u0627\u0644\u062d\u0627\u0631\u062b\u064a', '+966511111111', 'dr.harithi@email.com', '${pass2}', 'doctor', true),
      ('b2222222-2222-2222-2222-222222222222', '\u062f. \u0633\u0627\u0631\u0629 \u0627\u0644\u0639\u0645\u0648\u062f\u064a', '+966522222222', 'dr.alamoudi@email.com', '${pass2}', 'doctor', true)
      ON CONFLICT DO NOTHING;
    `);

    await pool.query(`
      INSERT INTO doctors (id, user_id, specialization, license_number, years_experience, bio, consultation_fee, is_available) VALUES
      ('c1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', '\u0627\u0644\u0637\u0628 \u0627\u0644\u0628\u0627\u0637\u0646\u064a', 'MD-2020-001', 8, '\u0627\u062e\u062a\u0635\u0627\u0635\u064a \u0637\u0628 \u0628\u0627\u0637\u0646\u064a \u0628\u062e\u0628\u0631\u0629 8 \u0633\u0646\u0648\u0627\u062a \u0641\u064a \u062a\u0634\u062e\u064a\u0635 \u0648\u0639\u0644\u0627\u062c \u0627\u0644\u0623\u0645\u0631\u0627\u0636 \u0627\u0644\u062f\u0627\u062e\u0644\u064a\u0629', 100, 'available'),
      ('c2222222-2222-2222-2222-222222222222', 'b2222222-2222-2222-2222-222222222222', '\u0637\u0628 \u0627\u0644\u0623\u0637\u0641\u0627\u0644', 'MD-2019-002', 6, '\u0627\u062e\u062a\u0635\u0627\u0635\u064a\u0629 \u0637\u0628 \u0623\u0637\u0641\u0627\u0644 \u0645\u0639 \u062e\u0628\u0631\u0629 \u0641\u064a \u0631\u0639\u0627\u064a\u0629 \u0627\u0644\u0623\u0637\u0641\u0627\u0644 \u0627\u0644\u062d\u062f\u064a\u062b\u064a\u0646', 120, 'available')
      ON CONFLICT DO NOTHING;
    `);

    // 2 Pharmacies
    await pool.query(`
      INSERT INTO users (id, full_name, phone, email, password_hash, user_type, is_verified) VALUES
      ('d1111111-1111-1111-1111-111111111111', '\u0635\u064a\u062f\u0644\u064a\u0629 \u0627\u0644\u0634\u0641\u0627\u0621', '+966533333333', 'pharmacy1@email.com', '${pass3}', 'pharmacy', true),
      ('d2222222-2222-2222-2222-222222222222', '\u0635\u064a\u062f\u0644\u064a\u0629 \u0627\u0644\u0635\u062d\u0629 \u0627\u0644\u0648\u0637\u0646\u064a\u0629', '+966544444444', 'pharmacy2@email.com', '${pass3}', 'pharmacy', true)
      ON CONFLICT DO NOTHING;
    `);

    await pool.query(`
      INSERT INTO pharmacies (id, user_id, pharmacy_name, license_number, address, address_lat, address_lng, delivery_range_km) VALUES
      ('e1111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', '\u0635\u064a\u062f\u0644\u064a\u0629 \u0627\u0644\u0634\u0641\u0627\u0621', 'PH-2021-001', '\u062d\u064a \u0627\u0644\u0634\u0641\u0627\u0621\u060c \u0627\u0644\u0631\u064a\u0627\u0636', 24.7681, 46.7010, 15),
      ('e2222222-2222-2222-2222-222222222222', 'd2222222-2222-2222-2222-222222222222', '\u0635\u064a\u062f\u0644\u064a\u0629 \u0627\u0644\u0635\u062d\u0629 \u0627\u0644\u0648\u0637\u0646\u064a\u0629', 'PH-2021-002', '\u062d\u064a \u0627\u0644\u0639\u0644\u064a\u0627\u060c \u062c\u062f\u0629', 21.4858, 39.1925, 10)
      ON CONFLICT DO NOTHING;
    `);

    console.log('Seed completed: 6 patients, 2 doctors, 2 pharmacies');
  } catch (err) {
    console.error('Seed failed:', err);
  } finally {
    pool.end();
  }
}

seed();
