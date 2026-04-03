export type Project = {
  id: string;
  title: string;
  description: string;
  link: string;
  imageUrl: string;
};

export type ContactFormData = {
  name: string;
  email: string;
  message: string;
};

export interface AboutInfo {
  background: string;
  skills: string[];
}