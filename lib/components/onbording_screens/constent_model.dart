import 'package:flutter/material.dart';

class UnbordingContent {
  String image;
  String title;
  String discription;
  List<String> accorditionList;
  List<String> accorditionTitle;
  List<String> accorditionDescrition;

  UnbordingContent(
      {required this.image,
      required this.title,
      required this.discription,
      required this.accorditionList,
      required this.accorditionTitle,
      required this.accorditionDescrition});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title:
          'Welcome to Madison Personal Accident Insurance with Terrorism & Political Risks Cover!',
      image: 'assets/logos/slide_one.png',
      discription:
          "Our Personal Accident Insurance with Terrorism & Political Risks Cover extension is designed to protect against the unexpected, while also offering coverage against Terrorism and Political Risk",
      accorditionList: [],
      accorditionTitle: [],
      accorditionDescrition: []
  ),
  UnbordingContent(
      title: 'The cover',
      image: 'assets/logos/slide_six.png',
      discription:
          "Our Personal accident insurance covers you financially in the case of an accident."
          "\nOne is covered in the case of:",
      accorditionList: [
        '1. Temporary total disability',
        '2. Permanent total disability',
        '3. Permanent total disability',
        '4. Medical expenses resulting from and accident',
        '5. Death'
      ],
      accorditionTitle: [],
      
      accorditionDescrition: []
  ),
  UnbordingContent(
      title: 'Benefits',
      image: 'assets/logos/slide_four.png',
      discription: '',
      accorditionList: [],
      accorditionTitle: [
        'In the event of a fatal accident/death',
        'If the accident results in permanent disability',
        'If the accident results in temporary disability',
        'Medical expenses'],
      accorditionDescrition: [
        'The sum insured is payable to registered beneficiaries in the event of accidental death.',
        'The policy pays a capital sum following an irreversible disability that makes one unable to pursue gainful employment.',
        'Our Personal accident cover in Kenya cover for temporary disability leading to loss of earnings for a given period of time. It is settled in terms of weekly earnings lost.',
        'The policy caters to medical expenses on a reimbursement basis for injuries sustained during the accident.'
      ]
  ),
  UnbordingContent(
      title: 'Key Features',
      image: 'assets/logos/slide_two.png',
      discription: '',
      accorditionList: [
        '1. Comprehensive Accident Coverage: Our policy compensates for bodily injuries resulting from accidents, offering protection for physical impairment, disablement, or death within twelve (12) months from the accident date.',
        '2. Accidental Death Benefit: Choose coverage between Kes. 100,000 to Kes. 10,000,000, providing a lump sum payment to designated beneficiaries in the event of the insured’s accidental death.',
        '3. Permanent Total Disablement Benefit: If an accident causes permanent total disablement, we offer a lump sum payment to help adjust to life changes and cover ongoing expenses.',
        '4. Permanent Partial Disablement Benefit: In the case of permanent partial disablement, receive a partial payment based on the severity of the disablement.',
        '5. Temporary Total Disablement Benefit: Receive compensation for temporary total disablement, supporting you during the recovery period and loss of income.',
        '6. Medical Expenses Reimbursement: Covering necessary medical treatment and hospitalization expenses incurred due to accidents, easing the financial burden.'
        '7. Hospital Cash Benefit: Receive daily cash benefits during hospitalization due to an accident, covering additional expenses.'
        '8. Last Expense Benefit: Assist your family with funeral and last expense costs in the event of accidental death.'
        '9. Coverage for Self and Family Members: Extend coverage to your spouse and children, ensuring their well-being during challenging times.'
        '10. Terrorism & Political Risks Extension: Additional protection against injuries or death resulting from acts of Terrorism, riot, strike, civil commotion, and malicious acts during the policy period.'
      ],
      accorditionTitle: [],
      
      accorditionDescrition: []
  ),
  UnbordingContent(
      title: 'Policy Exclutions',
      image: 'assets/logos/slide_five.png',
      discription: '',
      accorditionList: [
        '1. War, civil war, mutiny, riot, strike, civil commotion, rebellion, revolution, insurrection, military or usurped power.',
        '2. Suicide or attempted suicide whether felonious or not, wilful, self injury.',
        '3. Breach of law on your part (unlawful activity).',
        '4. Voluntary, wilful or negligent exposure of the Insured to needless peril except for the purpose of saving human life.',
        '5. Insanity or venereal disease.',
        '6. Indulgence in alcohol, narcotics or drugs not prescribed by a qualified medical practitioner.'
        '7. Participation in hazardous sports.'
        '8. Pregnancy or childbirth related illness.'
        '9. Aviation except as a passenger on a recognized airline operating on regular scheduled air routes or in any chartered aircraft duly licensed as a recognized carrier.'
      ],
      accorditionTitle: [],
      
      accorditionDescrition: []
  ),
  UnbordingContent(
      title: 'Frequently asked questions',
      image: 'assets/logos/slide_three.png',
      discription: '',
      accorditionList: [],
      accorditionTitle: [
        '1. What does the accisental Death Benefit Cover?',
        '2. What types of disabilitys are covered?',
        '3. What medical expenses are covered?',
        '4. Can I ninclude my family members under this policy?',
        '5. What is the terrorism & Political Risks Extention?',
        '6. Are premium affordable for individual coverage?',
        '7. How do I apply for One Million Family Personal Accident Insurance?'],
      accorditionDescrition: [
        'Our Accidental Death Benefit offers a lump sum payment between Kes. 100,000 to Kes. 10,000,000 to designated beneficiaries in case of accidental death.',
        'Our policy covers permanent and temporary disabilities, including permanent total disablement, permanent partial disablement, and temporary total disablement caused by accidents. ',
        'We cover necessary medical treatment and hospitalization expenses resulting from accidents, alleviating financial burdens.',
        'Yes, you can extend coverage to your spouse and children, offering protection for your entire family.',
        'Our extension covers injuries or death resulting from acts of Terrorism, riot, strike, civil commotion, and malicious acts during the policy period, ensuring added protection. ',
        'Yes, premiums start from Kes. 1,095 per person, providing affordable individual coverage with flexible benefits. We have also discounted the rate for the spouse and children if one takes up cover for the family.',
        'Applying is easy! Dial *828# or reach out to your trusted insurance advisors for a seamless application process.'
      ]
  ),
];
