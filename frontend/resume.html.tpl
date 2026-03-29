<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Wong Yong Xiang - Resume</title>
  <link rel="stylesheet" href="resume_style.css" />
</head>
<body>
  <div class="container">
    
    <header class="resume-header">
      <div class="header-left">
        <h1>Wong Yong Xiang</h1>
      <p class="contact"> 
        <a href="https://www.linkedin.com/in/wongyongxiang" target="_blank">LinkedIn</a> | 
        <a href="https://github.com/wongyx" target="_blank">GitHub</a> |
        <a href="https://www.wongyx.com" target="_blank">My Website</a>
      </p>
      </div>

      <div class="visitor-counter">
        <div class="label">Visitor count</div>
        <div class="count" id="visitorCount">...</div>
      </div>
    </header>

    <section>
      <h2>Education</h2>
      <div class="item">
        <h3>National University of Singapore</h3>
        <span class="date">Aug 2021 – May 2025</span>
        <p>Bachelor of Computing (Honours) in Computer Science</p>
        <ul>
          <li>Specialisation in Cyber Security and Computer Networks</li>
        </ul>
      </div>
    </section>

    <section>
      <h2>Skills</h2>
      <ul class="skills">
        <li><b>Security Tools & Testing:</b> Burp Suite, Postman, Golang code review, Python scripting</li>
        <li><b>Cloud & DevOps:</b> AWS, Terraform, Git, GitHub CI/CD, Linux systems</li>
        <li><b>Languages:</b> Native proficiency in English and Mandarin Chinese</li>
      </ul>
    </section>

    <section>
      <h2>Certificates</h2>
      <ul>
        <a href="https://www.credly.com/badges/4e47f965-80ed-4c16-926d-81efba043f65">AWS Solutions Architect – Associate</a>
      </ul>
    </section>

    <section>
      <h2>Work Experience</h2>
      <div class="item">
        <h3>Matrixport – Cybersecurity Engineer</h3>
        <span class="date">July 2025 – Present</span>
        <ul>
          <li>Integrated 'Shift Left' security practices into the SDLC by partnering with engineering teams for the development of internal systems. Conduct deep-dive audits of Golang source code and RESTful APIs, remediating vulnerabilities prior to production.</li>
          <li>Constructed the mapping of complex AWS and on-premise network topology, and performed security audits of firewalls and AWS Security Groups to eliminate misconfigurations and enforce least-privilege access.</li>
          <li>Developed and evaluated a prototype fuzzer based on recent research</li>
          <li>Led Proof of Concept (POC) evaluations for third-party security vendors, aligning technical capabilities with organisational risk requirements to ensure high-ROI tool acquisition.</li>
          <li>Executed security assessments of client-facing applications at the pre-launch stage using BurpSuite, ensuring all vulnerabilities were addressed to protect the brand and user data upon public release</li>
        </ul>
      </div>
      
      <div class="item">
        <h3>DSO National Laboratories – Cybersecurity Research Intern</h3>
        <span class="date">May 2024 – Aug 2024</span>
        <ul>
          <li>Made use of state of the art fuzzers like AFL++ to test and identify vulnerabilities in Linux programs</li>
          <li>Analysed the C code of existing AFL++ variant to understand how the program works and identify areas of improvement</li>
          <li>Developed an prototype fuzzer built on top of current fuzzer written in C by integrating new research ideas published in recent years. Tested prototype and confirmed its improvement in performance. Documented code changes for the supervisor</li>
          <li>Researched on new fuzzing strategies that improves efficiency on detecting vulnerabilities in program</li>
          <li>Debugged C/C++ programs using GDB</li>
        </ul>
      </div>

      <div class="item">
        <h3>Phillip Capital – Software Development Intern</h3>
        <span class="date">May 2023 – Jul 2023</span>
        <ul>
          <li>Developed a web scraping program using Python for retrieving mass data quickly from the web, freeing up staff's time from repetitive tasks.</li>
          <li>Analysed a C++ program that retrieves and processes real time data. Documented program's flow for the software development team.</li>
          <li>Analysed existing data flow framework, and suggested ideas on a necessary revamp in existing framework due to a change of data source.</li>
          <li>Made use of robotic process automation to replace important SMS messages with Microsoft Teams messages, helping save $2000-$3000 every month.</li>
        </ul>
      </div>
    </section>

    <section>
      <h2>Projects</h2>
      <div class="item">
        <h3>Cloud Resume Challenge</h3>
        <ul>
          <li>Deployed serverless cloud resume website on AWS using S3, CloudFront, Lambda, and DynamoDB.</li>
          <li>Provisioned multi-environment infrastructure using Terraform with remote state in S3 and locking via DynamoDB.</li>
          <li>Built CI/CD pipeline with GitHub Actions integrating security scanning (CodeQL, tfsec) and SCA (Syft + Grype).</li>
          <li>Secured pipeline access using GitHub OIDC authentication with least-privilege IAM policies.</li>
        </ul>
      </div>
    </section>

    <section>
      <h2>Hobbies & Interests</h2>
      <ul>
        <li>Casual hiking</li>
        <li>Travelling to natural destinations around the world</li>
      </ul>
    </section>
  </div>
  <script>
    const url = "${api_endpoint}";
    fetch(url, {
      method: "POST"
    }).then(response => response.json())
    .then(data => {
      document.getElementById("visitorCount").textContent = data.current_count;
    })
    .catch(error => {
      console.error(error);
      document.getElementById("visitorCount").textContent = "Error loading count";
    });
  </script> 
</body>
</html>
