import 'package:flutter/material.dart';
import 'package:haru_admin/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF2F2F2),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A4A4A),
            primary: const Color(0xFF4A4A4A),
            secondary: const Color(0xFF4A4A4A),
            surface: const Color(0xFFFFFFFF),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          // alert dialog theme
          dialogTheme: const DialogTheme(
            backgroundColor: Color(0xFFFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            surfaceTintColor: Color(0xFF484848),
            alignment: Alignment.center,
            titleTextStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
            contentTextStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          dropdownMenuTheme: const DropdownMenuThemeData(
            textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF585858),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFFFFFFFF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(
                  color: Color(0xFFAFAFAF),
                  width: 1,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
            ),
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(
                Color(0xFFFFFFFF),
              ),
              shadowColor: null,
              elevation: WidgetStatePropertyAll<double>(0),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(
              color: Color(0xFF9C9C9C),
              width: 1,
            ),
          ),
          radioTheme: RadioThemeData(
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF585858); // Color when selected
              }
              return const Color(0xFFCDCDCD); // Border color when unselected
            }),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
      ),
    ),
  );
}
