import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pizza_delivery/app/modules/auth/controllers/login_controller.dart';
import 'package:pizza_delivery/app/modules/splash/view/splash_page.dart';
import 'package:pizza_delivery/app/shared/components/pizza_delivery_button.dart';
import 'package:pizza_delivery/app/shared/components/pizza_delivery_input.dart';
import 'package:pizza_delivery/app/shared/mixins/loader_mixin.dart';
import 'package:pizza_delivery/app/shared/mixins/messages_mixin.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class LoginPage extends StatelessWidget {
  static const router = '/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
            create: (context) => LoginController(),
            child: LoginContent(),
          ),
        ),
      ),
    );
  }
}

class LoginContent extends StatefulWidget {
  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with LoaderMixin, MessagesMixin {
  final formKey = GlobalKey<FormState>();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final obscurePasswordValueNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    final loginController = context.read<LoginController>();
    loginController.addListener(() {
      showHideLoaderHelper(context, loginController.showLoader);
      if (!isNull(loginController.error)) {
        showSnackBarMessage(
          message: loginController.error,
          context: context,
          color: Colors.red,
        );
      }

      if (loginController.loginSuccess) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SplashPage.router, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 250,
        ),
        Container(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PizzaDeliveryInput(
                    'E-mail',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailEditingController,
                    validator: (value) {
                      if (!isEmail(value?.toString() ?? '')) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: obscurePasswordValueNotifier,
                    builder: (_, obscurePasswordValueNotifierValue, child) {
                      return PizzaDeliveryInput(
                        'Senha',
                        controller: passwordEditingController,
                        suffixIcon: Icon(FontAwesome.key),
                        suffixIconOnPressed: () {
                          obscurePasswordValueNotifier.value =
                              !obscurePasswordValueNotifierValue;
                        },
                        obscureText: obscurePasswordValueNotifierValue,
                        validator: (value) {
                          if (!isLength(value.toString(), 6)) {
                            return 'Senha deve conter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  PizzaDeliveryButton(
                    'Login',
                    height: 50,
                    labelColor: Colors.white,
                    labelSize: 18,
                    buttonColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        context.read<LoginController>().login(
                              emailEditingController.text,
                              passwordEditingController.text,
                            );
                      }
                    },
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  FlatButton(
                    child: Text(
                      'Cadastre-se',
                      style: TextStyle(fontSize: 20, fontFamily: 'Arial'),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
