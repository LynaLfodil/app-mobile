import 'package:flutter/material.dart';
import '../../common/color_extention.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF23414E),
        title: const Text(
          'Health Blog',
          style: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xFFB9E7F0),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB9E7F0)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Topics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins",
                color: Color(0xFF23414E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore expert advice on various health topics to support your wellbeing',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
                color: Color(0xFF23414E),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildBlogCard(
                    context,
                    title: 'Diabetes Diet',
                    icon: Icons.food_bank,
                    color: const Color(0xFF5F99A2).withOpacity(0.9),
                    onTap: () => _navigateToAdvice(context, 'Diabetes Diet'),
                  ),
                  _buildBlogCard(
                    context,
                    title: 'Pregnancy Care',
                    icon: Icons.pregnant_woman,
                    color: const Color(0xFF5F99A2).withOpacity(0.9),
                    onTap: () => _navigateToAdvice(context, 'Pregnancy Care'),
                  ),
                  _buildBlogCard(
                    context,
                    title: 'Heart Health',
                    icon: Icons.favorite,
                    color: const Color(0xFF5F99A2).withOpacity(0.9),
                    onTap: () => _navigateToAdvice(context, 'Heart Health'),
                  ),
                  _buildBlogCard(
                    context,
                    title: 'Mental Wellness',
                    icon: Icons.psychology,
                    color: const Color(0xFF5F99A2).withOpacity(0.9),
                    onTap: () => _navigateToAdvice(context, 'Mental Wellness'),
                  ),
                  _buildBlogCard(
                    context,
                    title: 'Exercise Tips',
                    icon: Icons.directions_run,
                    color: const Color(0xFF5F99A2).withOpacity(0.9),
                    onTap: () => _navigateToAdvice(context, 'Exercise Tips'),
                  ),
                  _buildBlogCard(
                    context,
                    title: 'Sleep Hygiene',
                    icon: Icons.bedtime,
                    color: const Color(0xFF5F99A2).withOpacity(0.9),
                    onTap: () => _navigateToAdvice(context, 'Sleep Hygiene'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: Colors.white.withOpacity(0.9),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAdvice(BuildContext context, String topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdviceDetailView(topic: topic),
      ),
    );
  }
}

class AdviceDetailView extends StatelessWidget {
  final String topic;

  const AdviceDetailView({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, dynamic>> adviceData = {
      'Diabetes Diet': {
        'image': 'assets/diabetes.jpg', // Replace with your image
        'content': '''
1. Choose healthy carbohydrates like fruits, vegetables, whole grains, and legumes.
2. Eat fiber-rich foods to help control blood sugar.
3. Limit saturated fats and trans fats.
4. Eat at regular times to maintain blood sugar levels.
5. Control portion sizes to manage calorie intake.
''',
      },
      'Pregnancy Care': {
        'image': 'lib/assets/img/undraw_expecting_j6le.png', // Replace with your image
        'content': '''
1. Take prenatal vitamins with folic acid.
2. Exercise regularly with doctor's approval.
3. Eat a balanced diet with plenty of fruits and vegetables.
4. Avoid alcohol, tobacco, and excessive caffeine.
5. Get plenty of rest and manage stress.
''',
      },
      'Heart Health': {
        'image': 'assets/heart.jpg', // Replace with your image
        'content': '''
1. Eat a diet rich in fruits, vegetables, and whole grains.
2. Limit saturated fats, trans fats, and sodium.
3. Exercise for at least 30 minutes most days.
4. Don't smoke and avoid secondhand smoke.
5. Maintain a healthy weight.
''',
      },
      'Mental Wellness': {
        'image': 'assets/mental.jpg', // Replace with your image
        'content': '''
1. Practice mindfulness and meditation.
2. Stay connected with friends and family.
3. Get regular physical activity.
4. Prioritize sleep and maintain a regular sleep schedule.
5. Seek professional help when needed.
''',
      },
      'Exercise Tips': {
        'image': 'lib/assets/img/undraw_indoor-bike_9lxj.png', // Replace with your image
        'content': '''
1. Start slowly and gradually increase intensity.
2. Find activities you enjoy to stay motivated.
3. Aim for at least 150 minutes of moderate activity weekly.
4. Include strength training twice a week.
5. Stay hydrated and listen to your body.
''',
      },
      'Sleep Hygiene': {
        'image': 'assets/sleep.jpg', // Replace with your image
        'content': '''
1. Maintain a consistent sleep schedule.
2. Create a relaxing bedtime routine.
3. Keep your bedroom cool, dark, and quiet.
4. Limit screen time before bed.
5. Avoid caffeine and large meals before bedtime.
''',
      },
    };

    final data = adviceData[topic] ?? {
      'image': 'assets/default.jpg',
      'content': 'No advice available for this topic.'
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF23414E),
        title: Text(
          topic,
          style: const TextStyle(
            fontFamily: "Poppins",
            color: Color(0xFFB9E7F0),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB9E7F0)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16/9,
              child: Image.asset(
                data['image'],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Advice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      color: Tcolor.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data['content'],
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins",
                      color: Tcolor.primary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/doctor_advice.jpg', // Add an image between advice and disclaimer
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB9E7F0).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Remember to consult with your healthcare provider before making any significant changes to your lifestyle.',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF23414E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}