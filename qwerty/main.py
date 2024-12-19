def main():
    users = int(input("Кол-во участников: "))

    loyalty = [0] * users
    empathy = [0] * users

    for i in range(users):
        loyalty[i] = float(input(f"Лояльность участника {i + 1}: "))
        empathy[i] = int(input(f"Эмпатия участника {i + 1}: "))

    for i in range(users):
        success = loyalty[i] * empathy[i]

        if success < 5:
            print(f"Игра неудачна. {success}")
            break
        elif 5 <= success < 7:
            print(f"Игра норм {success}")
            break
        elif success >= 7:
            print(f"Игра очень удачна. {success}")
            break

if __name__ == "__main__":
    main()

pos = nx.spring_layout(G)
plt.figure(figsize=(8, 6))
nx.draw(G, pos, with_labels=True, node_color='skyblue', node_size=2000, font_size=12, font_weight='bold')

edge_labels = nx.get_edge_attributes(G, 'weight')
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels)

plt.title("Граф участников с весами рёбер")
plt.show()