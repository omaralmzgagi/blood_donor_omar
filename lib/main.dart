import 'package:flutter/material.dart';

void main() => runApp(const BloodDonorApp());

class Donor {
  final String name, blood, district, phone;
  final bool available;
  const Donor(this.name, this.blood, this.district, this.phone, this.available);
}

const districts = [
  'الكل','مدينة إب','الظهار','المشنة','جبلة','السياني','العدين','يريم',
  'السدة','النادرة','القفر','حبيش','المخادر','مذيخرة','فرع العدين',
  'بعدان','السبرة','ذي السفال','الرضمة','الشعر','حزم العدين'
];

const donors = [
  Donor('أحمد محمد','O+','الظهار','770000001',true),
  Donor('محمد علي','O+','المشنة','770000002',true),
  Donor('خالد عبدالله','A+','جبلة','770000003',true),
  Donor('عمر حسن','B+','مدينة إب','770000004',true),
  Donor('علي صالح','O-','السياني','770000005',true),
  Donor('سعيد أحمد','AB+','يريم','770000006',false),
  Donor('حسن قاسم','A-','العدين','770000007',true),
  Donor('إبراهيم علي','B+','بعدان','770000008',true),
];

class BloodDonorApp extends StatelessWidget {
  const BloodDonorApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner:false,
    title:'متبرع إب',
    theme:ThemeData(
      useMaterial3:true,
      colorSchemeSeed:Colors.red,
      fontFamily:'Arial',
      scaffoldBackgroundColor:const Color(0xfff7f7f7),
    ),
    home:const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState()=>_HomePageState();
}

class _HomePageState extends State<HomePage> {
  String blood='O+', district='الكل';
  List<Donor> results=donors;

  void search(){
    setState(()=>results=donors.where((d)=>
      d.blood==blood && d.available &&
      (district=='الكل'||d.district==district)).toList());
  }

  @override
  Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(
      title:const Text('🩸 متبرع إب',style:TextStyle(fontWeight:FontWeight.bold)),
      centerTitle:true, backgroundColor:Colors.red,foregroundColor:Colors.white,
    ),
    body:ListView(padding:const EdgeInsets.all(16),children:[
      Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(
        crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          const Text('ابحث عن متبرع بالدم',
            style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
          const SizedBox(height:6),
          const Text('محافظة إب - نسخة تجريبية'),
          const SizedBox(height:16),
          DropdownButtonFormField<String>(
            value:blood,decoration:const InputDecoration(
            labelText:'فصيلة الدم',border:OutlineInputBorder()),
            items:['A+','A-','B+','B-','AB+','AB-','O+','O-']
              .map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),
            onChanged:(v)=>setState(()=>blood=v!)),
          const SizedBox(height:12),
          DropdownButtonFormField<String>(
            value:district,decoration:const InputDecoration(
            labelText:'المديرية / المنطقة',border:OutlineInputBorder()),
            items:districts.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),
            onChanged:(v)=>setState(()=>district=v!)),
          const SizedBox(height:14),
          FilledButton.icon(onPressed:search,
            icon:const Icon(Icons.search),label:const Text('بحث')),
        ],
      ))),
      const SizedBox(height:12),
      Text('المتبرعون المتاحون: ${results.length}',
        style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
      const SizedBox(height:8),
      if(results.isEmpty) const Card(child:Padding(
        padding:EdgeInsets.all(24),
        child:Center(child:Text('لا يوجد متبرع مطابق حاليًا')))),
      ...results.map((d)=>Card(child:ListTile(
        leading:CircleAvatar(
          backgroundColor:Colors.red.shade50,
          child:Text(d.blood,style:TextStyle(
            color:Colors.red.shade700,fontWeight:FontWeight.bold))),
        title:Text(d.name,style:const TextStyle(fontWeight:FontWeight.bold)),
        subtitle:Text('${d.blood} • إب - ${d.district}\n🟢 متاح للتبرع'),
        isThreeLine:true,
        trailing:IconButton(
          icon:const Icon(Icons.phone,color:Colors.green),
          onPressed:()=>showDialog(context:context,builder:(_)=>
            AlertDialog(title:Text(d.name),
              content:Text('رقم تجريبي: ${d.phone}'),
              actions:[TextButton(onPressed:()=>Navigator.pop(context),
                child:const Text('إغلاق'))]))),
      ))),
      const SizedBox(height:12),
      FilledButton.icon(
        style:FilledButton.styleFrom(backgroundColor:Colors.red),
        onPressed:()=>Navigator.push(context,
          MaterialPageRoute(builder:(_)=>const RegisterPage())),
        icon:const Icon(Icons.person_add),
        label:const Text('سجل كمتبرع')),
      OutlinedButton.icon(
        onPressed:()=>Navigator.push(context,
          MaterialPageRoute(builder:(_)=>const RequestPage())),
        icon:const Icon(Icons.emergency),
        label:const Text('طلب دم عاجل')),
    ]),
  );
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override State<RegisterPage> createState()=>_RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage>{
  final name=TextEditingController(), phone=TextEditingController();
  String blood='O+',district='مدينة إب';
  @override void dispose(){name.dispose();phone.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('التسجيل كمتبرع')),
    body:ListView(padding:const EdgeInsets.all(16),children:[
      TextField(controller:name,decoration:const InputDecoration(
        labelText:'الاسم',border:OutlineInputBorder())),
      const SizedBox(height:12),
      TextField(controller:phone,keyboardType:TextInputType.phone,
        decoration:const InputDecoration(labelText:'رقم الهاتف',
        border:OutlineInputBorder())),
      const SizedBox(height:12),
      DropdownButtonFormField<String>(value:blood,decoration:const InputDecoration(
        labelText:'فصيلة الدم',border:OutlineInputBorder()),
        items:['A+','A-','B+','B-','AB+','AB-','O+','O-']
        .map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),
        onChanged:(v)=>setState(()=>blood=v!)),
      const SizedBox(height:12),
      DropdownButtonFormField<String>(value:district,decoration:const InputDecoration(
        labelText:'المديرية',border:OutlineInputBorder()),
        items:districts.where((x)=>x!='الكل').map((x)=>DropdownMenuItem(
          value:x,child:Text(x))).toList(),
        onChanged:(v)=>setState(()=>district=v!)),
      const SizedBox(height:18),
      FilledButton(onPressed:(){
        if(name.text.isEmpty||phone.text.isEmpty)return;
        showDialog(context:context,builder:(_)=>AlertDialog(
          title:const Text('تم التسجيل تجريبيًا'),
          content:const Text('سيتم في النسخة الحقيقية التحقق من رقم الهاتف وحفظ البيانات بأمان.'),
          actions:[TextButton(onPressed:(){Navigator.pop(context);Navigator.pop(context);},
            child:const Text('حسنًا'))]));
      },child:const Text('تسجيل')),
    ]),
  );
}

class RequestPage extends StatefulWidget{
  const RequestPage({super.key});
  @override State<RequestPage> createState()=>_RequestPageState();
}
class _RequestPageState extends State<RequestPage>{
  String blood='O+',district='مدينة إب';
  final hospital=TextEditingController();
  @override void dispose(){hospital.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('طلب دم عاجل')),
    body:ListView(padding:const EdgeInsets.all(16),children:[
      const Text('أنشئ طلبًا تجريبيًا ليظهر لاحقًا للمتبرعين.',
        style:TextStyle(fontSize:17)),
      const SizedBox(height:16),
      DropdownButtonFormField<String>(value:blood,decoration:const InputDecoration(
        labelText:'فصيلة الدم المطلوبة',border:OutlineInputBorder()),
        items:['A+','A-','B+','B-','AB+','AB-','O+','O-']
        .map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),
        onChanged:(v)=>setState(()=>blood=v!)),
      const SizedBox(height:12),
      DropdownButtonFormField<String>(value:district,decoration:const InputDecoration(
        labelText:'المديرية',border:OutlineInputBorder()),
        items:districts.where((x)=>x!='الكل').map((x)=>DropdownMenuItem(
          value:x,child:Text(x))).toList(),
        onChanged:(v)=>setState(()=>district=v!)),
      const SizedBox(height:12),
      TextField(controller:hospital,decoration:const InputDecoration(
        labelText:'اسم المستشفى',border:OutlineInputBorder())),
      const SizedBox(height:18),
      FilledButton.icon(onPressed:(){
        showDialog(context:context,builder:(_)=>AlertDialog(
          title:const Text('تم إنشاء الطلب'),
          content:Text('طلب ${blood} في إب - ${district}'),
          actions:[TextButton(onPressed:(){Navigator.pop(context);Navigator.pop(context);},
            child:const Text('حسنًا'))]));
      },icon:const Icon(Icons.send),label:const Text('إرسال الطلب')),
    ]),
  );
}
