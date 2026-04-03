# Qasim Jutt's Portfolio

Welcome to the portfolio website of Qasim Jutt. This project showcases my work, skills, and provides a way for visitors to contact me.

## Project Structure

The project is structured as follows:

```
qasim-jutt-portfolio
├── src
│   ├── components
│   │   ├── Header.tsx        # Navigation bar component
│   │   ├── Footer.tsx        # Footer section component
│   │   ├── ProjectCard.tsx   # Component to display individual project details
│   │   └── ContactForm.tsx   # Form for user inquiries
│   ├── pages
│   │   ├── index.tsx         # Main landing page
│   │   ├── projects.tsx      # Page listing all projects
│   │   ├── about.tsx         # Page with information about Qasim Jutt
│   │   └── contact.tsx       # Page with contact form
│   ├── styles
│   │   └── globals.css       # Global CSS styles
│   └── types
│       └── index.ts          # TypeScript types and interfaces
├── public
│   └── assets                # Static assets (images, icons)
├── .github
│   └── workflows
│       └── ci-cd.yml        # CI/CD pipeline configuration
├── package.json              # npm configuration file
├── tsconfig.json             # TypeScript configuration file
├── next.config.js            # Next.js configuration settings
└── README.md                 # Project documentation
```

## Getting Started

To get started with this project, follow these steps:

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/qasim-jutt-portfolio.git
   ```
2. Navigate to the project directory:
   ```
   cd qasim-jutt-portfolio
   ```
3. Install the dependencies:
   ```
   npm install
   ```
4. Run the development server:
   ```
   npm run dev
   ```

## Deployment

This project uses GitHub Actions for CI/CD. The pipeline is configured to run on pushes to the `main` branch and on pull requests targeting the `main` branch. 

## Contact

For inquiries, please use the contact form available on the website or reach out via email. 

Thank you for visiting my portfolio!