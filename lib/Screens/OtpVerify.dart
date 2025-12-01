import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thenaukrimitra/Screens/Login.dart';
import '../main_Screen/main_screen.dart';
import '../provider/Auth_Provider.dart';
import 'CreateProfile.dart';

class OtpVerify extends StatefulWidget {
  final  String phone;
  const OtpVerify({super.key,required this.phone});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final List<TextEditingController> otpControllers = List.generate(
    4,
        (_) => TextEditingController(),
  );

  bool _isLoading = false;
  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _canResend = false;
    _start = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _resendOtp() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("OTP resent successfully!")));
    startTimer();
  }

  void _verifyOtp() async {
    final otp = otpControllers.map((e) => e.text).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter complete OTP")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.verifyOtp(widget.phone, otp);
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "OTP Verified")),
      );

      final bool isNewUser = result['isNewUser'] ?? true;
      if (isNewUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CreateProfile(phone: widget.phone,),
          ),
        );
      } else {
        // Existing user → MainScreen
        var selectedImage;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainScreen(
              fullName: authProvider.fullName ?? "",
              gender: authProvider.gender ?? "",
              education: authProvider.education ?? "",
              workExperience: authProvider.workExperience ?? "",
              salary: authProvider.salary ?? "0",
              imageFile: null,
              imageUrl: authProvider.imageUrl,
              skills: authProvider.skills ?? [],
              title: '',
              image: '',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Invalid OTP")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(236, 236, 245, 1),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  color: Colors.blue,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 50),
                const Center(
                  child: Text(
                    '4-digit code was sent to',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.phone,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xff0156ce),
                          ),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: InkWell(
                            onTap: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login( phone: widget.phone),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Icon(Icons.edit, size: 16, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                const SizedBox(height: 24),
                const Text(
                  'Enter OTP',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                        (index) => Container(
                      width: 50,
                      margin: const EdgeInsets.only(right: 20),
                      child: TextField(
                        controller: otpControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (index < 3) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).unfocus();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: _canResend ? _resendOtp : null,
                    child: Text(
                      _canResend
                          ? "Resend OTP"
                          : "Resend OTP 00:${_start.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _canResend ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0156ce),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: _isLoading ? null : _verifyOtp,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Verify Phone Number',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:thenaukrimitra/Screens/Login.dart';
// import '../main_Screen/main_screen.dart';
// import '../provider/Auth_Provider.dart';
// import 'CreateProfile.dart';
//
// class OtpVerify extends StatefulWidget {
//   final String phone;
//   const OtpVerify({super.key,required this.phone});
//
//   @override
//   State<OtpVerify> createState() => _OtpVerifyState();
// }
//
// class _OtpVerifyState extends State<OtpVerify> {
//   final List<TextEditingController> otpControllers = List.generate(
//     4,
//     (_) => TextEditingController(),
//   );
//
//   bool _isLoading = false;
//   Timer? _timer;
//   int _start = 60;
//   bool _canResend = false;
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   void startTimer() {
//     _canResend = false;
//     _start = 60;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_start == 0) {
//         setState(() {
//           _canResend = true;
//         });
//         _timer?.cancel();
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }
//
//   void _resendOtp() {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text("OTP resent successfully!")));
//     startTimer();
//   }
//
//   void _verifyOtp() async {
//     final otp = otpControllers.map((e) => e.text).join();
//     if (otp.length < 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter complete OTP")),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final result = await authProvider.verifyOtp(widget.phone, otp);
//     setState(() => _isLoading = false);
//
//     if (result['success'] == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? "OTP Verified")),
//       );
//
//       final bool isNewUser = result['isNewUser'] ?? true;
//       if (isNewUser) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CreateProfile(phone: widget.phone),
//           ),
//         );
//       } else {
//         // Existing user → MainScreen
//         var selectedImage;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => MainScreen(
//               fullName: authProvider.fullName ?? "",
//               gender: authProvider.gender ?? "",
//               education: authProvider.education ?? "",
//               workExperience: authProvider.workExperience ?? "",
//               salary: authProvider.salary ?? "0",
//               imageFile: null, // ⚠️ File ke liye null rakho
//               imageUrl: authProvider.imageUrl, // ✅ server se aaya URL
//               skills: authProvider.skills ?? [],
//               title: '',
//               image: '',
//             ),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? "Invalid OTP")),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     for (var controller in otpControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color.fromRGBO(236, 236, 245, 1),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   color: Colors.blue,
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const SizedBox(height: 50),
//                 const Center(
//                   child: Text(
//                     '4-digit code was sent to',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Center(
//                   child: Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: widget.phone,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Color(0xff0156ce),
//                           ),
//                         ),
//                         const WidgetSpan(
//                           child: Icon(
//                             Icons.edit,
//                             size: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Enter OTP',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     4,
//                     (index) => Container(
//                       width: 50,
//                       margin: const EdgeInsets.only(right: 20),
//                       child: TextField(
//                         controller: otpControllers[index],
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         maxLength: 1,
//                         decoration: const InputDecoration(
//                           counterText: '',
//                           fillColor: Colors.white,
//                           filled: true,
//                           border: OutlineInputBorder(),
//                         ),
//                         onChanged: (value) {
//                           if (value.isNotEmpty) {
//                             if (index < 3) {
//                               FocusScope.of(context).nextFocus();
//                             } else {
//                               FocusScope.of(context).unfocus();
//                             }
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Center(
//                   child: TextButton(
//                     onPressed: _canResend ? _resendOtp : null,
//                     child: Text(
//                       _canResend
//                           ? "Resend OTP"
//                           : "Resend OTP 00:${_start.toString().padLeft(2, '0')}",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: _canResend ? Colors.blue : Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff0156ce),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     onPressed: _isLoading ? null : _verifyOtp,
//                     child: _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             'Verify Phone Number',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// old and new wala hai nahi hai ye sirf otp verify

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/Auth_Provider.dart';
// import 'CreateProfile.dart';
//
// class OtpVerify extends StatefulWidget {
//   final String phone;
//
//   const OtpVerify({super.key, required this.phone});
//
//   @override
//   State<OtpVerify> createState() => _OtpVerifyState();
// }
//
// class _OtpVerifyState extends State<OtpVerify> {
//   final List<TextEditingController> otpControllers =
//   List.generate(4, (_) => TextEditingController());
//
//   bool _isLoading = false;
//   Timer? _timer;
//   int _start = 60; // 1 minute countdown
//   bool _canResend = false;
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   void startTimer() {
//     _canResend = false;
//     _start = 60;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_start == 0) {
//         setState(() {
//           _canResend = true;
//         });
//         _timer?.cancel();
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }
//
//   void _resendOtp() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("OTP resent successfully!")),
//     );
//     startTimer(); // restart the timer
//   }
//
//   void _verifyOtp() async {
//     final otp = otpControllers.map((e) => e.text).join();
//     if (otp.length < 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter complete OTP")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final result = await authProvider.verifyOtp(widget.phone, otp);
//     setState(() => _isLoading = false);
//
//     if (result['success'] == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? "OTP Verified")),
//       );
//         Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => CreateProfile(
//            phone: widget.phone,
//         )),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? "Invalid OTP")),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     for (var controller in otpControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color.fromRGBO(236, 236, 245, 1),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   color: Colors.blue,
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const SizedBox(height: 50),
//                 const Center(
//                   child: Text(
//                     '4-digit code was sent to',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Center(
//                   child: Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: widget.phone,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Color(0xff0156ce),
//                           ),
//                         ),
//                         const WidgetSpan(
//                           child: Icon(Icons.edit, size: 14, color: Colors.grey),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Enter OTP',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     4,
//                         (index) => Container(
//                       width: 50,
//                       margin: const EdgeInsets.only(right: 20),
//                       child: TextField(
//                         controller: otpControllers[index],
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         maxLength: 1,
//                         decoration: const InputDecoration(
//                           counterText: '',
//                           fillColor: Colors.white,
//                           filled: true,
//                           border: OutlineInputBorder(),
//                         ),
//                         onChanged: (value) {
//                           if (value.isNotEmpty) {
//                             if (index < 3) {
//                               FocusScope.of(context).nextFocus();
//                             } else {
//                               FocusScope.of(context).unfocus();
//                             }
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Center(
//                   child: TextButton(
//                     onPressed: _canResend ? _resendOtp : null,
//                     child: Text(
//                       _canResend
//                           ? "Resend OTP"
//                           : "Resend OTP 00:${_start.toString().padLeft(2, '0')}",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: _canResend ? Colors.blue : Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff0156ce),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     onPressed: _isLoading ? null : _verifyOtp,
//                     child: _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                       'Verify Phone Number',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// resend without time use

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/Auth_Provider.dart';
// import 'CreateProfile.dart';
//
// class OtpVerify extends StatefulWidget {
//   final String phone;
//
//   const OtpVerify({
//     super.key,
//     required this.phone,
//   });
//
//   @override
//   State<OtpVerify> createState() => _OtpVerifyState();
// }
//
// class _OtpVerifyState extends State<OtpVerify> {
//   final List<TextEditingController> otpControllers =
//   List.generate(4, (_) => TextEditingController());
//
//   bool _isLoading = false;
//
//   void _verifyOtp() async {
//     final otp = otpControllers.map((e) => e.text).join(); // OTP combine
//     if (otp.length < 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter complete OTP")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final result = await authProvider.verifyOtp(widget.phone, otp);
//     setState(() => _isLoading = false);
//
//     if (result['success'] == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? "OTP Verified")),
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const CreateProfile()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? "Invalid OTP")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color.fromRGBO(236, 236, 245, 1),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   color: Colors.blue,
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const SizedBox(height: 50),
//                 const Center(
//                   child: Text(
//                     '4-digit code was sent to ',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Center(
//                   child: Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: widget.phone,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Color(0xff0156ce),
//                           ),
//                         ),
//                         const WidgetSpan(
//                           child: Icon(Icons.edit, size: 14, color: Colors.grey),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Enter OTP',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     4,
//                         (index) => Container(
//                       width: 50,
//                       margin: const EdgeInsets.only(right: 20),
//                       child: TextField(
//                         controller: otpControllers[index],
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         maxLength: 1,
//                         decoration: const InputDecoration(
//                           counterText: '',
//                           fillColor: Colors.white,
//                           filled: true,
//                           border: OutlineInputBorder(),
//                         ),
//                         onChanged: (value) {
//                           if (value.isNotEmpty) {
//                             if (index < 3) {
//                               FocusScope.of(context).nextFocus();
//                             } else {
//                               FocusScope.of(context).unfocus();
//                             }
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Resend OTP 00:29',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff0156ce),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     onPressed: _isLoading ? null : _verifyOtp,
//                     child: _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                       'Verify Phone Number',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/Auth_Provider.dart';
// import 'CreateProfile.dart';
//
// class OtpVerify extends StatefulWidget {
//   final String phone;
//
//   const OtpVerify({
//     super.key,
//     required this.phone,
//   });
//
//   @override
//   State<OtpVerify> createState() => _OtpVerifyState();
// }
//
// class _OtpVerifyState extends State<OtpVerify> {
//   final List<TextEditingController> otpControllers =
//   List.generate(4, (_) => TextEditingController());
//
//   bool _isLoading = false;
//
//   void _verifyOtp() async {
//     final otp = otpControllers.map((e) => e.text).join(); // OTP combine
//     if (otp.length < 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter complete OTP")),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final result = await authProvider.verifyOtp(widget.phone, otp);
//     setState(() => _isLoading = false);
//
//     if (result['success'] == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? "OTP Verified")),
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const CreateProfile()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? "Invalid OTP")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color.fromRGBO(236, 236, 245, 1),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   color: Colors.blue,
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const SizedBox(height: 50),
//                 const Center(
//                   child: Text(
//                     '4-digit code was sent to ',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Center(
//                   child: Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: widget.phone,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Color(0xff0156ce),
//                           ),
//                         ),
//                         const WidgetSpan(
//                           child: Icon(Icons.edit, size: 14, color: Colors.grey),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Enter OTP',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     4,
//                         (index) => Container(
//                       width: 50,
//                       margin: const EdgeInsets.only(right: 20),
//                       child: TextField(
//                         controller: otpControllers[index],
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         maxLength: 1,
//                         decoration: const InputDecoration(
//                           counterText: '',
//                           fillColor: Colors.white,
//                           filled: true,
//                           border: OutlineInputBorder(),
//                         ),
//                         onChanged: (value) {
//                           if (value.isNotEmpty) {
//                             if (index < 3) {
//                               FocusScope.of(context).nextFocus();
//                             } else {
//                               FocusScope.of(context).unfocus();
//                             }
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Resend OTP 00:29',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff0156ce),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     onPressed: _isLoading ? null : _verifyOtp,
//                     child: _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                       'Verify Phone Number',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'CreateProfile.dart';
//
// class OtpVerify extends StatefulWidget {
//   const OtpVerify({super.key});
//
//   @override
//   State<OtpVerify> createState() => _OtpVerifyState();
// }
// class _OtpVerifyState extends State<OtpVerify> {
//   final List<TextEditingController> otpControllers =
//   List.generate(4, (_) => TextEditingController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true, // Ensure the layout resizes for keyboard
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//             color: Color.fromRGBO(236, 236, 245, 1)
//           // gradient: LinearGradient(
//           //   begin: Alignment.topCenter,
//           //   end: Alignment.bottomCenter,
//           //   colors: [
//           //     Colors.white,
//           //     Color(0xFF7C82FF),
//           //   ],
//           // ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   color: Colors.blue,
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const SizedBox(height: 50),
//                 const Center(
//                   child: Text(
//                     '4-digit code was sent to ',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const Center(
//                   child: Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: '93880*****',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Color(0xff0156ce),
//                           ),
//                         ),
//                         WidgetSpan(
//                           child: Icon(Icons.edit, size: 14, color: Colors.grey),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Enter OTP',
//                   style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     4,
//                         (index) => Container(
//                       width: 50,
//                       margin: const EdgeInsets.only(right: 20),
//                       child: TextField(
//                         controller: otpControllers[index],
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         maxLength: 1,
//                         decoration: const InputDecoration(
//                           counterText: '',
//                           fillColor: Colors.white,
//                           filled: true,
//                           border: OutlineInputBorder(),
//                         ),
//                         onChanged: (value) {
//                           if (value.isNotEmpty) {
//                             if (index < 3) {
//                               FocusScope.of(context).nextFocus();
//                             } else {
//                               // If last digit entered, hide keyboard
//                               FocusScope.of(context).unfocus();
//                             }
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Resend OTP 00:29',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff0156ce),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     onPressed: () {
//                       // Optionally validate OTP here before navigating
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const CreateProfile()),
//                       );
//                     },
//                     child: const Text(
//                       'Verify Phone Number',
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
