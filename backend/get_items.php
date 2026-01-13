<?php
require_once "db.php";

$sql = "SELECT id, type, title, description, location, contact, status, created_at
        FROM lost_found_items
        ORDER BY id DESC";

$result = mysqli_query($con, $sql);
$items = [];

while ($row = mysqli_fetch_assoc($result)) {
  $items[] = $row;
}

echo json_encode($items);
mysqli_close($con);
?>
