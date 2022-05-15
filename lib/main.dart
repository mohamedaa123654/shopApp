import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/shared/cubit/cubit.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';
import 'package:shop/shared/resources/theme_manager.dart';

import 'layout/cubit/cubit.dart';
import 'layout/shop_layout.dart';
import 'modules/login_screen/login_screen.dart';
import 'modules/on_boarding_screen/on_boarding_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/components/constants.dart';
import 'shared/cubit/states.dart';
import 'shared/network/local/cache_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () async {
      DioHelper.init();
      await CacheHelper.init();
      bool? isDark = CacheHelper.getData(key: 'isDark');
      Widget widget;

      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
      token = CacheHelper.getData(key: 'token');
      print(token);

      if (onBoarding != null) {
        if (token != null) {
          widget = const ShopLayout();
        } else {
          widget = ShopLoginScreen();
        }
      } else {
        widget = OnBoardingScreen();
      }

      runApp(MyApp(
        isDark: isDark,
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {},
        builder: (BuildContext context, AppState state) {
          AppCubit cubit = AppCubit.get(context);
          return MaterialApp(
            theme: lightTheme,
            // darkTheme: darkMode,
            // themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: startWidget,
          );
        },
      ),
    );
  }
}
