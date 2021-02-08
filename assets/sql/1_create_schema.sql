CREATE TABLE bookings(
    storeID TEXT,
    slotID TEXT,
    employeeName TEXT,
    bookingDate TEXT,
    storeName TEXT,
    storeToken TEXT
);

CREATE TABLE notifications(
    notificationDate TEXT,
    notificationID INTEGER PRIMARY KEY
);
