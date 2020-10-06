import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pizza_delivery/app/modules/auth/controllers/register_controller.dart';
import 'package:pizza_delivery/app/shared/components/pizza_delivery_button.dart';
import 'package:pizza_delivery/app/shared/components/pizza_delivery_input.dart';
import 'package:pizza_delivery/app/shared/mixins/loader_mixin.dart';
import 'package:pizza_delivery/app/shared/mixins/messages_mixin.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class RegisterPage extends StatelessWidget {
  static const router = '/register';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
            create: (context) => RegisterController(),
            child: RegisterContent(),
          ),
        ),
      ),
    );
  }
}

class RegisterContent extends StatefulWidget {
  @override
  _RegisterContentState createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent>
    with LoaderMixin, MessagesMixin {
  final formKey = GlobalKey<FormState>();

  final obscureTextPassword = ValueNotifier<bool>(true);
  final obscureTextConfirmPassword = ValueNotifier<bool>(true);

  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = context.read<RegisterController>();
    controller.addListener(() {
      showHideLoaderHelper(context, controller.loading);
      if (!isNull(controller.error)) {
        showSnackBarMessage(
          message: controller.error,
          context: context,
          color: Colors.red,
        );
      }
      if (controller.registerSuccess) {
        showSnackBarMessage(
          message: 'Usuário cadastrado com sucesso!',
          context: context,
          color: Colors.green,
        );
        Future.delayed(
          Duration(seconds: 1),
          () => Navigator.of(context).pop(),
        );
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
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Cadastre-se',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PizzaDeliveryInput(
                    'Nome',
                    controller: nameEditingController,
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return 'Nome obrigatório';
                      }
                      return null;
                    },
                  ),
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
                  ValueListenableBuilder<bool>(
                    valueListenable: obscureTextPassword,
                    builder: (_, obscureTextPasswordValue, child) {
                      return PizzaDeliveryInput(
                        'Senha',
                        suffixIcon: Icon(FontAwesome.key),
                        controller: passwordEditingController,
                        obscureText: obscureTextPasswordValue,
                        suffixIconOnPressed: () {
                          obscureTextPassword.value = !obscureTextPasswordValue;
                        },
                        validator: (value) {
                          if (!isLength(value.toString(), 6)) {
                            return 'Senha precisa ter pelo menos 6 caractéres';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: obscureTextConfirmPassword,
                    builder: (_, obscureTextConfirmPasswordValue, child) {
                      return PizzaDeliveryInput(
                        'Confirma Senha',
                        suffixIcon: Icon(FontAwesome.key),
                        controller: confirmPasswordEditingController,
                        obscureText: obscureTextConfirmPasswordValue,
                        suffixIconOnPressed: () {
                          obscureTextConfirmPassword.value =
                              !obscureTextConfirmPasswordValue;
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Confirmar Senha é Obrigatório';
                          } else if (passwordEditingController.text !=
                              value.toString()) {
                            return 'Senha e confirma Senha não conferem';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  PizzaDeliveryButton(
                    'Salvar',
                    height: 50,
                    labelColor: Colors.white,
                    labelSize: 18,
                    buttonColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        context.read<RegisterController>().registerUser(
                              nameEditingController.text,
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
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          RegisterPage.router, (route) => false);
                    },
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
