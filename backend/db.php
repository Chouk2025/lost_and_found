<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

$DB_HOST = "YOUR_HOST_NAME";
$DB_USER = "YOUR_USER_NAME";
$DB_PASS = "YOUR_PASSWORD";
$DB_NAME = "YOUR_DATABASE_NAME";

$con = mysqli_connect($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if (!$con) {
  http_response_code(500);
  echo json_encode(["error" => "DB connection failed"]);
  exit;
}

mysqli_set_charset($con, "utf8mb4");
?>
