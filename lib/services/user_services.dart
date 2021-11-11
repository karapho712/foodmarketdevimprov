part of 'services.dart';

class UserServices {
  static Future<ApiReturnValue<User>> signIn(String email, String password, {http.Client? client}) async {
    if (client == null) {
      client = http.Client();
    }
    String url = baseUrl + 'login';

    var response = await client.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String, String>{'email': email, 'password': password}));

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Please try again');
    }

    var data = jsonDecode(response.body);
    User.token = data['data']['access_token'];
    User value = User.fromJson(data['data']['user']);

    return ApiReturnValue(value: value);

    // await Future.delayed(Duration(milliseconds: 300));

    // return ApiReturnValue(value: mockUser);
    // return ApiReturnValue(message: "Wrong Email or Password");
  }

  static Future<ApiReturnValue<User>> signUp(User user, String password,
      {File? pictureFile, http.Client? client}) async {
    if (client == null) {
      client = http.Client();
    }

    String url = baseUrl + 'register';
    print(url);

    var response = await client.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(<String, String>{
        'name': user.name!,
        'email': user.email!,
        'password': password,
        'password_confirmation': password,
        'address': user.address!,
        'city': user.city!,
        'houseNumber': user.houseNumber!,
        'phoneNumber': user.phoneNumber!,
      }),
    );

    if (response.statusCode == 422) {
      // // print(client);
      // // print("Url invalid");
      // // print(response.body.toString());
      // // print(response.statusCode);
      // // Map<String, dynamic> bodydata = jsonDecode(response.body.toString());
      Map<String, dynamic> bodydata = json.decode(response.body);
      // print(bodydata);
      Map<String, dynamic> map = bodydata["errors"];
      // //List<dynamic> data = map["dataKey"];

      // * Bisa begini untuk return value dari map nya
      // String errorMessage = '';
      // var number = 0;
      // for (var entry in map.entries) {
      //   // print(entry.key);
      //   // print(entry.value);
      //   var messagevalue = entry.value.toString();
      //   errorMessage += messagevalue.replaceAll(new RegExp(r'[^\w\s]+'), '');
      //   if (number != map.entries.length - 1) {
      //     errorMessage += ('\n');
      //   }
      //   number++;
      // }
      // print(errorMessage);
      // print(map.entries.length);

      // * BISA BEGINI JUGA UNTUK RETURN VALUE NYA DARI MAP NYA
      String listerror = '';
      var number = 0;
      map.entries.forEach((errorMessage) {
        var messagevalue = errorMessage.value.toString();
        listerror += messagevalue.replaceAll(new RegExp(r'[^\w\s]+'), '');
        if (number != map.entries.length - 1) {
          listerror += ('\n');
        }
        number++;
      });

      //  * Bisa juga begini untuk return value dari mapnya
      // String semuaError = map.values.toString();
      // print(semuaError);

      // print(bodydata['errors']);
      return ApiReturnValue(message: listerror);
    } else if (response.statusCode != 200) {
      return ApiReturnValue(message: "Please try again later");
    }

    var data = jsonDecode(response.body);

    User.token = data['data']['access_token'];
    User value = User.fromJson(data['data']['user']);

    if (pictureFile != null) {
      ApiReturnValue<String> result = await uploadProfilePicture(pictureFile);

      if (result.value != null) {
        value = value.copyWith(picturePath: "http://foodmarket-backend.buildwithangga.id/storage/" + result.value!);
      }
    }

    return ApiReturnValue(value: value);
  }

  static Future<ApiReturnValue<String>> uploadProfilePicture(File pictureFile, {http.MultipartRequest? request}) async {
    String url = baseUrl + 'user/photo';
    var uri = Uri.parse(url);

    if (request == null) {
      request = http.MultipartRequest("POST", uri)
        ..headers["Content-Type"] = "application/json"
        ..headers["Authorization"] = "Bearer ${User.token}";
    }

    var multipartfile = await http.MultipartFile.fromPath('file', pictureFile.path);
    request.files.add(multipartfile);

    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);

      String imagePath = data['data'][0];

      return ApiReturnValue(value: imagePath);
    } else {
      return ApiReturnValue(message: 'Uploading Profile Picture Failed');
    }
  }
}
