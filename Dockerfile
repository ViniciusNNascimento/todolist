# Estágio 1: Build (Construção)
FROM maven:3.8.7-openjdk-17 AS build

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o arquivo pom.xml para que as dependências sejam baixadas em cache
COPY todolist/pom.xml .

# Baixa as dependências do projeto
RUN mvn dependency:go-offline

# Copia o restante do código da aplicação
COPY todolist/src ./src

# Empacota a aplicação em um arquivo .jar executável
RUN mvn package

# Estágio 2: Runtime (Execução)
FROM openjdk:17-jre-slim

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o arquivo .jar do estágio de build para o estágio de execução
COPY --from=build /app/target/*.jar app.jar

# Define a porta que a aplicação vai expor
EXPOSE 8080

# Comando para rodar a aplicação quando o contêiner for iniciado
ENTRYPOINT ["java", "-jar", "app.jar"]