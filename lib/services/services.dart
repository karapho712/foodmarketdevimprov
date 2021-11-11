import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterfoodlaravelproject/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:intl/number_symbols_data.dart';

part 'user_services.dart';
part 'food_services.dart';
part 'transaction_services.dart';

String baseUrl = 'http://foodmarket-backend.buildwithangga.id/api/';
