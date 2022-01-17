-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Янв 12 2022 г., 08:06
-- Версия сервера: 8.0.27-0ubuntu0.20.04.1
-- Версия PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `mprint`
--

-- --------------------------------------------------------

--
-- Структура таблицы `tasks`
--

CREATE TABLE `tasks` (
  `id` int NOT NULL,
  `datein` date NOT NULL,
  `username` varchar(32) NOT NULL,
  `printer` varchar(25) NOT NULL,
  `cartridge` varchar(25) NOT NULL,
  `workstatus` varchar(64) DEFAULT NULL,
  `location` varchar(64) DEFAULT NULL,
  `dateout` date DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `tasks`
--

INSERT INTO `tasks` (`id`, `datein`, `username`, `printer`, `cartridge`, `workstatus`, `location`, `dateout`, `comment`) VALUES
(1, '2021-01-01', 'Мячин В.А.', 'Canon MF4018', 'FX-10', 'В ожидании заправки/ремонта', 'Дом связи. Группа выч.техники', NULL, NULL),
(2, '2022-01-12', 'Коротченко Ю.А.', 'Canon MF4410', '735', 'В ожидании заправки/ремонта', 'Дом связи', NULL, '');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
