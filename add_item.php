<?php
require_once "db.php";

$data = json_decode(file_get_contents("php://input"), true);
if ($data === null) {
  http_response_code(400);
  echo json_encode(["error" => "Invalid JSON"]);
  exit;
}

$type = strtoupper(trim($data["type"] ?? ""));
$title = trim($data["title"] ?? "");
$description = trim($data["description"] ?? "");
$location = trim($data["location"] ?? "");
$contact = trim($data["contact"] ?? "");

if (($type !== "LOST" && $type !== "FOUND") || $title === "" || $location === "" || $contact === "") {
  http_response_code(400);
  echo json_encode(["error" => "Missing/invalid fields"]);
  exit;
}

$stmt = mysqli_prepare($con,
  "INSERT INTO lost_found_items (type, title, description, location, contact) VALUES (?, ?, ?, ?, ?)"
);
mysqli_stmt_bind_param($stmt, "sssss", $type, $title, $description, $location, $contact);

if (mysqli_stmt_execute($stmt)) {
  echo json_encode(["message" => "Item added"]);
} else {
  http_response_code(500);
  echo json_encode(["error" => "Insert failed"]);
}

mysqli_stmt_close($stmt);
mysqli_close($con);
?>
