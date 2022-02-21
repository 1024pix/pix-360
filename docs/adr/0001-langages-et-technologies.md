# 1. Langages, frameworks et technologies

Date : 2022-01-07

## État

Accepté

## Contexte

Nous développons cette application dans le cadre d’un projet de fin d’études. 
La partie consacrée au développement de ce projet s’étale sur 4 semaines avec un Proof Of Concept (POC) livrable à la 3ème semaine.
Les membres du groupe ont des parcours différents compte tenu de leur alternance respective, ils forment ainsi un groupe de développement dont le niveau est hétérogène.

Le but de ce projet est de faciliter la demande de [feedbacks 360](https://www.qualitystreet.fr/2012/11/15/outils-pratiques-du-manager-agile-3-feedback-360)
en centralisant la demande, la rédaction et la lecture de ceux-ci sur une unique plateforme.

Ce projet est réalisé en collaboration avec Pix qui exprime un besoin pour cette application, mais qui n’a pas trouvé de solution qui leur  convient à ce moment. 

Avec Pix, nous partageons les mêmes valeurs sur l’IT :

- le **Web** plutôt que les clients lourds ou applications mobiles natives,
- l’**Open Source** plutôt que les solutions propriétaires
- et les **standards** universels (HTML, CSS, HTTP, REST, etc.) plutôt que des solutions inédites

Étant donné le contexte de développement, la plateforme doit être :
- fiable,
- accessible,
- restreinte aux personnels de la structure,
- sécurisée,
- performante

Par ailleurs, la plateforme doit respecter les caractéristiques suivantes :
- Être facile à appréhender
- Évolutive
- Facilement réutilisable par d’autres acteurs

Enfin, la plateforme doit permettre simplement, rapidement et à moindre coût l’émergence, l’ajout, la suppression, la mise à jour et la maintenance de services SI de différentes sortes, en fonction des besoins métier ou technique.

## Décision

### **Limiter les technologies et leur diversité**

En phase avec le proverbe *less is more*, nous pensons que la simplicité d’un SI découle (entre autres) de la réduction des ressources impliquées et de leur bon usage.

Par ailleurs, limiter les technologies permet de limiter les expertises requises pour développer de façon autonome, productive et confortable sur le projet. 
Ainsi dans notre cas où nous léguons le projet à Pix à la fin de celui-ci, cela permettra de :

- simplifier la montée en compétences 
- réduire l’effort et le coût de maintenance

### Utiliser Ruby on Rails

Ruby On Rails (RoR) apporte plusieurs points positifs pour réaliser ce projet.

#### Développeur Expérience

Mettre en place une application en Ruby on Rails se fait facilement. 
Aussi, Ruby on Rails insiste sur le paradigme : Convention Over Configuration, qui permet donc de gagner du temps sur les choses simples.

Ajouté à cela [Rubocop](https://rubocop.org/), un linter et formatter, 
permet de veiller au respect de certaines conventions.

Ces trois points nous permettent donc de gagner du temps et d’assurer une certaine qualité de code. 

#### Déploiement 

Ruby on Rails étant un monolithe, ce dernier permet de déployer une seule application et limite donc les coûts d’hébergement.

Aussi, grâce à [Active Record](https://guides.rubyonrails.org/active_record_basics.html), 
la gestion des migrations de la base de données est gérée nativement, ce qui facilite grandement les évolutions de l'application.  

#### Études 

Comme il s’agit d’une application développée dans le cadre de nos études, utiliser Ruby on Rails nous permet aussi de découvrir un nouveau langage : Ruby et un framework : Ruby on Rails.
