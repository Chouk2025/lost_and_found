-- Lost & Found App - Database Schema 
-- Note: Sample data uses fake contact info.

CREATE TABLE IF NOT EXISTS lost_found_items (
  id INT NOT NULL AUTO_INCREMENT,
  type ENUM('LOST','FOUND') NOT NULL,
  title VARCHAR(120) NOT NULL,
  description TEXT,
  location VARCHAR(160) NOT NULL,
  contact VARCHAR(120) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

-- Optional sample data (safe for public repositories)
INSERT INTO lost_found_items (type, title, description, location, contact) VALUES
('LOST',  'Keys',          'Two keys on a red keychain',     'Campus cafeteria',        'contact@example.com'),
('FOUND', 'USB Flash Drive','Black 32GB USB drive',          'Engineering Lab 2',       'contact@example.com'),
('LOST',  'Wallet',        'Brown wallet, no cash inside',   'Parking lot',             '+000 000 000'),
('FOUND', 'Water Bottle',  'Blue bottle with stickers',      'Library entrance',        'contact@example.com');
