# Blood Donor Ibb — APK / Codemagic

هذه النسخة مخصصة لبناء **Android APK فقط** عبر Codemagic.

1. ارفع المشروع إلى Codemagic.
2. اختر workflow: `android-apk`.
3. شغّل Build.
4. الملف الناتج: `build/app/outputs/flutter-apk/app-release.apk`

يتم إنشاء مفتاح توقيع مؤقت أثناء كل Build، لذلك الـAPK الناتج موقّع وقابل للتثبيت مباشرة.

مهم: هذا مناسب للاختبار والتثبيت المباشر. للنشر على Google Play أو تحديثات مستقبلية بنفس هوية التوقيع، استخدم keystore ثابتًا محفوظًا بأمان في Codemagic.
